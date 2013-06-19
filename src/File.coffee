async = require('async')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')
PluginWrapper = require('./PluginWrapper')


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
File = Tools.implementing PluginWrapper, Logger, ReadableEntity, TreeElement, class _File
class File
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()

  ###*
   * Load a file from its path
   * This method must be called once when loading the module for the first time.
   * After this, the 'reload' method will reload the file.
   *
   * @for Module
   * @method loadFromFilename
   * @param {String} filename The location of the file
   * @param {Function} callback : parameters (err : error occured) 
  ###
  loadFromFilename: (filename, cb) ->
    self = @
    cb = cb || ->

    try
      # we read the file and update the content
      @updateContentFromFile(filename, 'utf8', (err) ->
        # there is no additional process on files unlike modules 
        #  and general configuration files
        # Everything else should be processed by external plugins
        cb(err); cb = ->
      )
    catch e
      cb(e); cb = ->



module.exports = File # export the class