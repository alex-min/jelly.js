async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

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
              self.getLogger().info("Unable to load plugin #{file} #{err}")
            cb()
          )
        , (err) -> cb(err))
      )
    catch e
      cb(e)
      
  readPluginFromPath: (dir, pluginName, cb) ->
    cb = cb || ->
    self = @

    try
      if dir == null || typeof dir == 'undefined'
        cb(new Error("An invalid 'null' value was given as directory for pluginName #{pluginName}")); cb = ->
        return
      if pluginName == null || typeof pluginName == 'undefined'
        cb(new Error("An invalid 'null' value was given as pluginName for directory #{dir}")); cb = ->
        return
      @getLogger().info("Reading plugin '#{pluginName}' <#{dir}>")
      fs.stat("#{dir}", (err, stats) ->
        if err?
          cb(new Error("#{dir} is an invalid directory : #{err}")); cb = ->
          return
        if !(stats.isDirectory())
          cb(new Error("#{dir} is not a directory on plugin #{pluginName}")); cb = ->
          return
        cb(); cb = ->
      )
    catch e
      cb(e)

module.exports = PluginDirectory # export the class