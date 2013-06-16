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

  unload: (cb) ->
    cb = cb || ->
    cb()

  readFile: (filename, cb) ->
    cb = cb || ->
    cb()

module.exports = PluginInterface # export the class