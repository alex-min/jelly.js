###*
 * GeneralConfiguration is a class dealing with GeneralConfiguration files
 * The main goal of this class is to provide read and process general configuration files
 * 
 * @class ReadableEntity
###
ReadableEntity = require('./ReadableEntity')
Tools = require('./Tools')

GeneralConfiguration = Tools.implementing Logger, ReadableEntity, class _GeneralConfiguration
class GeneralConfiguration
  
  
module.exports = GeneralConfiguration # export the class