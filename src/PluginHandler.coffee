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
PluginHandler = Tools.implementing Logger, ReadableEntity, TreeElement, class _PluginHandler
class PluginHandler
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()

  reload: (cb) ->
    cb = cb || ->
    cb()

module.exports = PluginHandler # export the class