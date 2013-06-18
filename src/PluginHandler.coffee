async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')
PluginInterface = require('./PluginInterface')

###*
 * PluginHandler is the child class of PluginDirectory.
 * Each PluginDirectory instance is suppose to contain a PluginHandler class with itself, multiple PluginInterface in it.
 * This class is dealing with configuration related to a plugin.
 * The code is handled by a PluginInterface class
 * 
 * @class PluginHandler
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
PluginHandler = Tools.implementing Logger, ReadableEntity, TreeElement, class _PluginHandler
class PluginHandler
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()
    @_pluginInterface = new PluginInterface()
    @_pluginInterface.setParent(this)
    @addChild(@_pluginInterface)


  # set default values for the general configuration file
  _setDefaultContent: (content) ->
    content.mainFile ?= 'main.js'
    return content

  ###*
   * Read config file of the plugin (/config.json).
   * This method will update the current content to the config file.
   * Before calling this function, make sure a directory is previously pushed as a content (by calling updateContent).
   * To set a new directory for the plugin, please call this.updateContent({directory:'newdir'}).
   * This method must be called again after to update the configuration file.
   *
   * @for PluginHandler
   * @method readConfigFile
   * @async
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
  ###
  readConfigFile: (cb) ->
    self = @
    cb = cb || ->

    try
      # get the config directory
      dir = @getLastDirectory()
      if dir == null
        cb(new Error('No directory is specified')); cb = ->
        return
      # get the config.json
      @readUpdateAndExecute("#{dir}/config.json", 'utf8', (err, data) ->
        if err?
          cb(new Error("Unable to read the plugin configuration file : #{err.message}")); cb = ->
          return
        # add default values to the content
        self._setDefaultContent(self.getLastExecutableContent())
        self.readMainEntryFile(cb); cb = ->
      )
    catch e
      cb(e)

  ###*
   * Read the main entry point of the plugin (default:main.js).
   * The name of the main entry file can be set from the plugin config.json with the entry 'mainFile'.
   * You must have set a directory ( updateContent({directory:'/dir/to/set'}) ) before using this method.  
   *
   * @for PluginHandler
   * @method readMainEntryFile
   * @async
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  readMainEntryFile: (cb) ->
    cb = cb || ->
    self = @

    # get the config directory
    dir = @getLastDirectory()
    if dir == null
      cb(new Error('No directory is specified'), null); cb = ->
      return

    # get the last revision of the config file
    content = @getLastExecutableContent()
    if content == null
      cb(new Error('The configuration file is not loaded (please call PluginHandler::readConfigFile before using this method)'), null); cb = ->
      return
    # reset default values (just in case)
    @_setDefaultContent(content)

    # read the mainFile
    @_pluginInterface.readUpdateAndExecute("#{dir}/#{content.mainFile}", 'utf8', (err, data) ->
      if err?
        cb(new Error("Unable to process <#{dir}/#{content.mainFile}> : #{err.message}"))
        return
      cb(null, data)
    )


  ###*
   * Get the PluginInterface instance associated with the class.
   * The PluginInterface instance is handling the main file (default:main.js) of the plugin.
   * The instance is created in the constructor, there is no need to call anything to create it.
   *
   * @for PluginHandler
   * @method getPluginInterface
   * @return {PluginInterface} The PluginInterface instance
  ###
  getPluginInterface: () -> return @_pluginInterface

  ###*
   * Reload the plugin.
   * Will call in the order : <ul>
   *  <li> <strong>readConfigFile</strong> :
   *    Read the config.json from the plugin</li>
   *  <li> <strong>readMainEntryFile</strong> :
   *    Read the main.js (or what is specified on the config.json file (mainFile entry)</li>
   *  <li> <strong>getPluginInterface().reload()</strong> :
   *    reload the current plugin.
   * </ul>
   * You must have set a directory ( updateContent({directory:'/dir/to/set'}) ) before using this method.  
   *
   * @for PluginHandler
   * @method reload
   * @async
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  reload: (cb) ->
    cb = cb || ->
    self = @

    # reading the 'config.json' config file
    @readConfigFile((err) ->
      if err?
        cb(err); cb = ->
        return
      # get the last revision of the config file
      content = self.getLastExecutableContent()
      
      # set some default values
      self._setDefaultContent(content)

      async.series([
        # first we read the main.js entry point of the plugin
        (cb) -> self.readMainEntryFile(cb)

        # then we reload the plugin
        (cb) -> self._pluginInterface.reload(cb)
 
      ], (err) ->
        cb(err)
      )
    )

module.exports = PluginHandler # export the class