async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

###*
 * SharedObjectManager is a class to manager {SharedObject}s
 * 
 * @class SharedObjectManager
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
SharedObjectManager = Tools.implementing Logger, ReadableEntity, class _SharedObject
class SharedObjectManager
  _constructor_: ->
    ;
  constructor: -> @_constructor_()

module.exports = SharedObjectManager # export the class
