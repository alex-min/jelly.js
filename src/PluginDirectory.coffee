async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')
PluginHandler = require('./PluginHandler')

###*
 * PluginDirectory is the parent class of PluginHandler.
 * Each Jelly instance is suppose to contain a PluginDirectory class with multiple PluginHandler in it.
 * This class is dealing only with general methods related to all plugins.
 * To use a plugin directly, look at the PluginHandler class.
 * 
 * @class PluginDirectory
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
PluginDirectory = Tools.implementing Logger, ReadableEntity, TreeElement, class _PluginDirectory
class PluginDirectory
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()

  ###*
   * Get the logger class for external usage
   *
   * @for PluginDirectory
   * @method readAllPlugins
   * @async
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
  ###
  readAllPlugins: (cb) ->
    self = @
    cb = cb || ->

    try
      jelly = @getParent()
      if jelly == null || typeof jelly == 'undefined'
        cb(new Error("The PluginDirectory class must be bound to a Jelly configuration file. Please call PluginDirectory::setParent() if you are using this class manualy.")); cb = ->
        return
      async.series([
        (cb) -> self.readPluginDirectory("#{__dirname}/plugins", cb)
        (cb) -> self.readPluginDirectory(jelly.getPluginDirectory(), cb)
      ], (err) ->
        cb(err); cb = ->
      )
    catch e
      cb(e)

  ###*
   * Read a entire folder full of plugins.
   * This method will read recursively the folder and load all plugins.
   * If a plugin is invalid, no error will be returned and the plugin will be ignored.
   * This method will call readPluginFromPath recursively.
   *
   * @for PluginDirectory
   * @method readPluginDirectory
   * @async
   * @param dir The directory to read
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
  ###
  readPluginDirectory: (dir, cb) ->
    self = @
    cb = cb || ->
    
    try
      if dir == null || typeof dir == 'undefined'
        cb(new Error('Invalid parameter: directory == null')); cb = ->
        return

      # for each plugin folder
      fs.readdir(dir, (err, files) ->
        if err?
          cb(err); cb = ->
          return
        async.map(files, (file, cb) ->
          # we load it
          self.readPluginFromPath("#{dir}/#{file}", file, (err) ->
            if err?
              self.getLogger().error("Unable to load plugin #{file} #{err}")
            cb()
          )
        , (err) -> cb(err))
      )
    catch e
      cb(e)

  ###*
   * Read a plugin from its directory.
   * This method will create multiple instances of the PluginHandler class and will attach them as child of the PluginDirectory. 
   * This method should return errors when the plugin is invalid.
   *
   * @for PluginDirectory
   * @method readPluginFromPath
   * @async
   * @param dir The directory to read
   * @param pluginName The pluginName which will be set as an id (usually its the folder name)
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
   * @param {PluginHandler} callback.pluginHandler The plugin instance created (or null if there is an error)
  ###     
  readPluginFromPath: (dir, pluginName, cb) ->
    cb = cb || ->
    self = @

    try
      if dir == null || typeof dir == 'undefined'
        cb(new Error("An invalid 'null' value was given as directory for pluginName #{pluginName}"), null); cb = ->
        return
      if pluginName == null || typeof pluginName == 'undefined'
        cb(new Error("An invalid 'null' value was given as pluginName for directory #{dir}"), null); cb = ->
        return
      @getLogger().info("Reading plugin '#{pluginName}' <#{dir}>")
      fs.stat("#{dir}", (err, stats) ->
        if err?
          cb(new Error("#{dir} is an invalid directory : #{err}"), null); cb = ->
          return
        if !(stats.isDirectory())
          cb(new Error("#{dir} is not a directory on plugin #{pluginName}"), null); cb = ->
          return
        pluginHandler = self.getChildById(pluginName)
        if pluginHandler == null
          pluginHandler = new PluginHandler()
          pluginHandler.setId(pluginName)
          pluginHandler.updateContent({directory:dir})
          pluginHandler.setParent(self)
        self.addChild(pluginHandler, (err) ->
          pluginHandler.reload((err) ->
            cb(err, pluginHandler); cb = ->
          )
        )
        
      )
    catch e
      cb(e)

module.exports = PluginDirectory # export the class