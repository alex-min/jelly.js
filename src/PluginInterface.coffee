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

  STATUS: {
    NOT_LOADED: 0
    LOADED: 1
  }

  unload: (cb) ->
    cb = cb || ->
    cb()

  load: (cb) ->
    cb = cb || ->
    cb()

  readFile: (filename, cb) ->
    self = @
    cb = cb || ->

    async.series([
      (cb) -> self.unload(cb)
      (cb) -> cb()

    ], (err) ->
      cb(err)
    )

module.exports = PluginInterface # export the class