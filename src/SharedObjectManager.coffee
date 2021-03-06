async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')
SharedObject = require('./SharedObject')

###*
 * SharedObjectManager is a class to manager {SharedObject}s
 *
 * 
 * @class SharedObjectManager
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
SharedObjectManager = Tools.implementing Logger, ReadableEntity, TreeElement, class _SharedObjectManager
class SharedObjectManager
  _constructor_: ->
    @_parentConstructor_();
  constructor: -> @_constructor_()

  ###*
   * Register an object to the {SharedObjectManager}.
   * Objects are stored internally as a {SharedObject} class.
   *
   * @for SharedObjectManager
   * @method registerObject
   * @param {String} PluginId The plugin id
   * @param {String} ObjectId The {SharedObject} id
   * @content {Object} Content The content to registed
   * @return {SharedObject} The sharedObject associated with the ids (or null)
  ###
  registerObject: (pluginId, objectId, content) ->
    # some parameter checks
    if typeof pluginId != 'string' || \
       typeof objectId != 'string' || \
       typeof content == 'undefined' || \
       content == null 
        return

    # get the plugin instance
    pluginTree = @getChildById(pluginId)

    # if the plugin is not registred yet
    if pluginTree == null
      pluginTree = new TreeElement()
      pluginTree.setId(pluginId)
      @addChild(pluginTree)
      pluginTree.setParent(this)

    # get the sharedobject associated with the plugin
    sharedObject = pluginTree.getChildById(objectId)

    # if the sharedobject is not registred yet
    if sharedObject == null
      sharedObject = new SharedObject()
      sharedObject.setId(objectId)
      sharedObject.setParent(pluginTree)
      pluginTree.addChild(sharedObject)

    # update the content to the content given as parameter
    sharedObject.updateContent(content)


  ###*
   * Get an object registred with the 'registerObject' method.
   * This method will return a {SharedObject} or null if nothing is found.
   *
   * @for SharedObjectManager
   * @method getObject
   * @param {String} PluginId The plugin id
   * @param {String} ObjectId The {SharedObject} id
   * @return {SharedObject} The sharedObject associated with the ids (or null)
  ###
  getObject: (pluginId, objectId) ->
    moduleSharedList = @getChildById(pluginId)
    if moduleSharedList == null
      return null
    # get the SharedObject associated with the objectid
    obj = moduleSharedList.getChildById(objectId)
    return obj


module.exports = SharedObjectManager # export the class
