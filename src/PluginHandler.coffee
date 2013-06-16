async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

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
    cb = cb || ->
    dir = @getLastDirectory()
    if dir == null
      cb(new Error("No directory is specified")); cb = ->
      return
    @readUpdateAndExecute("#{dir}/config.json", 'utf8', (err, data) ->
      if err?
        cb(new Error("Unable to read the plugin configuration file : #{err.message}")); cb = ->
        return
      cb(null)
    )

  reload: (cb) ->
    cb = cb || ->
    @readConfigFile(cb)

module.exports = PluginHandler # export the class