
ReadableEntity = require('./ReadableEntity')
Tools = require('./Tools')
TreeElement = require('./TreeElement')
Logger = require('./Logger')

###*
 * GeneralConfiguration is a class dealing with GeneralConfiguration files
 * The main goal of this class is to provide read and process general configuration files
 * 
 * @class GeneralConfiguration
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
GeneralConfiguration = Tools.implementing Logger, ReadableEntity, TreeElement, class _GeneralConfiguration
class GeneralConfiguration
  GeneralConfiguration: true
  constructor: -> @_constructor_()
  _constructor_:->


  
module.exports = GeneralConfiguration # export the class