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
    @_parentConstructor_()
    
  ###*
   * Searching for a pluginHandler recursively for a specifid id.
   * {PluginList} -> {PluginDirectory} -> {PluginHandler} -> {PluginInterface}.
   *
   * @for PluginList
   * @method getPluginHandlerById
   * @param {String} id The id to search  
  ###
  getPluginHandlerById: (id) ->
    return null if id == null || typeof id == 'undefined'

    for directory in @getChildList()
      for handler in directory.getChildList()
        if id == handler.getId()
          return handler
    return null

module.exports = PluginList # export the class