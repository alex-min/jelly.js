async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

###*
 * SharedObject is a class to share objects between plugins.
 * 
 * @class SharedObject
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
SharedObject = Tools.implementing Logger, ReadableEntity, class _SharedObject
class SharedObject
  _constructor_: ->
    ;
  constructor: -> @_constructor_()

module.exports = SharedObject # export the class
