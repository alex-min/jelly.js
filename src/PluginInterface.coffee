async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

###*
 * PluginInterface is the child class of PluginHandler.
 * Each PluginHandler instance is suppose to contain a PluginInterface class.
 * This class is dealing directly with the plugin code.
 * 
 * @class PluginInterface
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
PluginInterface = Tools.implementing Logger, ReadableEntity, TreeElement, class _PluginInterface
class PluginInterface
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()
    @_status = PluginInterface::STATUS.NOT_LOADED

  ###*
   *  @property {Object} STATUS
   *  @c
   *  @attribute {Int} NOT_LOADED The plugin is not loaded
   *  @attribute {Int} LOADED The plugin is loaded
  ###
  STATUS: {
    NOT_LOADED: 0
    LOADED: 1
  }

  ###*
   * Get the current status of the plugin.
   * Currently, two values are possible : <ul>
   *  <li><strong> PluginInterface::STATUS.NOT_LOADED </strong> : The plugin is currently not loaded.</li>
   *  <li><strong> PluginInterface::STATUS.LOADED </strong> : The plugin is loaded </li></ul>
   *
   * @for PluginInterface
   * @method getStatus
   * @return {PluginInterface::STATUS} Current status of the plugin
  ###
  getStatus: () ->
    return @_status

  ###*
   * Set the current status of the plugin.
   * Currently, two values are possible : <ul>
   *  <li><strong> PluginInterface::STATUS.NOT_LOADED </strong> : The plugin is currently not loaded.</li>
   *  <li><strong> PluginInterface::STATUS.LOADED </strong> : The plugin is loaded </li></ul>
   *
   * @for PluginInterface
   * @method setStatus
   * @param {PluginInterface::STATUS} New status of the plugin
   * @return {PluginInterface::STATUS} New status of the plugin (or null if the status is invalid)
  ###
  setStatus: (status) ->
    if status == PluginInterface::STATUS.NOT_LOADED \
      || status == PluginInterface::STATUS.LOADED
        @_status = status
    return null


  ###*
   * This method will trigger exports.unload on the main plugin file.
   * This method must be called when reloading the plugin to let the plugin know a reload event is happening.
   *
   * @for PluginInterface
   * @method unload
   * @async
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  unload: (cb) ->
    cb = cb || ->
    self = @

    # get the last revision of the config file
    content = @getLastExecutableContent()

    # there is no content
    if content == null
      # unload should not trigger any errors when there is no content
      @getLogger().warn('Unable to unload plugin : There is no content')
      cb(null); cb = ->
      return

    # the content is strange
    if typeof content != 'object'
      @getLogger().warn('Unable to unload plugin : The content is not an object')
      cb(null); cb = ->
      return

    # there is no unload function declared
    if typeof content.unload != 'function'
      @getLogger().warn('Unable to unload plugin: There is no unload function exported in the plugin file')
      cb(null); cb = ->
      return

    # there is no need to load multiple times the same module
    if @getStatus() == PluginInterface::STATUS.NOT_LOADED
      cb()
      return

    # calling the unload method with this as content
    content.unload.call(this, () ->
      self.setStatus(PluginInterface::STATUS.NOT_LOADED)
      cb()
    )

  ###*
   * This method will trigger exports.load on the main plugin file.
   * This method must be called when reloading the plugin to let the plugin know a reload event is happening.
   *
   * @for PluginInterface
   * @method load
   * @async
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  load: (cb) ->
    cb = cb || ->
    self = @

    # get the last revision of the config file
    content = @getLastExecutableContent()

    # there is no content
    if content == null
      # unload should not trigger any errors when there is no content
      @getLogger().warn('Unable to load plugin : There is no content')
      cb(null); cb = ->
      return

    # the content is strange
    if typeof content != 'object'
      @getLogger().warn('Unable to load plugin : The content is not an object')
      cb(null); cb = ->
      return

    # there is no unload function declared
    if typeof content.load != 'function'
      @getLogger().warn('Unable to load plugin: There is no unload function exported in the plugin file')
      cb(null); cb = ->
      return

    # there is no need to load multiple times the same module
    if @getStatus() == PluginInterface::STATUS.LOADED
      cb()
      return

    # calling the unload method with this as content
    content.load.call(this, () ->
      self.setStatus(PluginInterface::STATUS.LOADED)
      cb()
    )

  ###*
   * This method is the equivalent of calling unload and load just after.
   * This will trigger exports.unload and export.load on the plugin main file.
   *
   * @for PluginInterface
   * @method reload
   * @async
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  reload: (cb) ->
    cb = cb || ->
    self = @

    async.series([
      (cb) -> self.unload(cb)
      (cb) -> self.load(cb) 
    ], (err) ->
      cb(err)
    )

  ###*
   * This method will trigger exports.oncall on the main plugin file.
   *
   * @for PluginInterface
   * @method oncall
   * @async
   * @param {Object} senderClass The sender class which the plugin should apply.
   * @param {Object} params Plugins parameters found in the configuration file
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  oncall: (senderClass, params, cb) ->
    cb = cb || ->
    self = @

    # get the last revision of the config file
    content = @getLastExecutableContent()
    # there is no content
    if content == null
      cb(new Error('Unable to oncall plugin : There is no content')); cb = ->
      return

    # the content is strange
    if typeof content != 'object'
      cb(new Error('Unable to oncall plugin : The content is not an object')); cb = ->
      return

    if @getParent() == null
      cb(new Error('Unable to oncall plugin : There is no PluginHandler parent on the plugin')); cb = ->
      return

    # must have a TreeElement as parent
    if Object.getPrototypeOf(@getParent()).TreeElement != true
      cb(new Error('The PluginInterface must extend from a TreeElement')); cb = ->
      return

    # there is no unload function declared
    if typeof content.oncall != 'function'
      cb(new Error("Unable to oncall plugin '#{@getParent().getId()}': There is no oncall function exported in the plugin file")); cb = ->
      return

    if senderClass == null || typeof senderClass == 'undefined'
      cb(new Error('The senderClass to bind the oncall method is invalid (null)')); cb = ->
      return

    # calling the unload method with this as content
    content.oncall.call(this, senderClass, params, (err) ->
      self.setStatus(PluginInterface::STATUS.LOADED)
      cb(err)
    )

module.exports = PluginInterface # export the class