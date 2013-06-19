async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

###*
 * PluginList is a class containing multiple PluginDirectory classes.
 * This class is the root class for all plugins.
 * 
 * @class PluginList
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
PluginList = Tools.implementing Logger, ReadableEntity, TreeElement, class _PluginList
class PluginList
  constructor: -> @_constructor_()
  _constructor_:->
    ;

module.exports = PluginList # export the class