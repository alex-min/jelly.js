async = require('async')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

###*
 * File is a class dealing with Module files.
 * Each file is suppose to be under its module folder on the projet.
 * The list of files for each module is defined on the module configuration file (on the fileList entry).
 * Example : on a 'menu' module, 'menu-animations.coffee' and 'menu-design.css' can both be represented with a File class. 
 * 
 * @class File
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
File = Tools.implementing Logger, ReadableEntity, TreeElement, class _File
class File
  File: true
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()

  loadFromFilename: (filename, cb) -> cb()

module.exports = File # export the class