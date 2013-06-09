
Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')

###*
 * Module is a class dealing with framework Modules.
 * Each module is suppose to be under a different folder on the projet.
 * The main goal is to provide modules with reusable functions (login form, calendar, administration, stastistics...)
 * 
 * @class Module
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
Module = Tools.implementing Logger, ReadableEntity, TreeElement, class _Module
class Module
  Module: true
  constructor: -> @_constructor_()
  _constructor_:->
    @_parentConstructor_()

  ###*
   * Load a module from its configuration file
   * This method must be called once when loading the module for the first time.
   * After this, only calls to the 'reload' method are allowed.
   *
   * @for Module
   * @method loadFromFilename
   * @param {String} filename The location of the file
   * @param {Function} callback : parameters (err : error occured) 
  ###
  loadFromFilename: (filename, cb) ->
    self = @
    cb = cb || ->

    @readUpdateAndExecute(filename, 'utf8', (err) ->
      if err
        cb(err)
      else
        self.reload(cb)
    )

  ###*
   * Do the necessary calls to reload the module (it must be loaded before calling this)
   * Currently equivalent to the readAllFiles method 
   *
   * @for Module
   * @method reload
   * @param {Function} callback : parameters (err : error occured) 
  ###
  reload: (cb) -> @readAllFiles(cb)


  ###*
   * Read all the files specified under the 'fileList' array section of each module configuration file
   *
   * @for Module
   * @method readAllFiles
   * @param {Function} callback : parameters (err : error occured) 
  ###  
  readAllFiles: (cb) ->
    self = @
    cb = cb || ->
    content = @getLastExecutableContent()
    if content == null
      cb(new Error('There is no executable content pushed on the Module Class')); cb = ->;
      return
    cb() # not implemented yet, [TODO]: implement reading of files


module.exports = Module # export the class