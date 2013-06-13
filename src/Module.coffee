async = require('async')
path = require('path')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')

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

  # set default values for the general configuration file
  _setDefaultContent: (content) ->
    content.fileList ?= []
    content.pathList ?= []
    content.plugins ?= []
    content.pluginParameters ?= {}
    content.modulePlugins = []
    content.modulePluginParameters = {}

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

    try
      @readUpdateAndExecute(filename, 'utf8', (err) ->
        try
          if err?
            cb(err); cb = ->
          else
            self.reload.call(self,cb); cb = ->
        catch e
          cb(e); cb = ->
      )
    catch e
      cb(e); cb = ->

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
    @getLogger().info('Reading all files')
 
    try
      # get the latest executable content
      content = @getLastExecutableContent()
      if content == null
        cb(new Error('There is no executable content pushed on the Module Class')); cb = ->;
        return
      # if there is no id set on the module, we cannot continue
      # to create an id for files, we need the module's id
      if @getId() == null
        cb(new Error("There is no Id bound to the module")); cb = ->;
        return

      # set default values on the the configuration file
      @_setDefaultContent(content)

      # for each file in the content list
      async.map(content.fileList, (file, cb) ->
        # for a module named 'menu' and a file named 'test.coffee'
        # the id will be 'menu-test.coffee'
        # this is preventing conflicts with other modules 
        fileId = "#{self.getId()}-#{file.name}"

        try
          file = self.getChildById(fileId)
          if file == null
              file = new File()
              file.setId(fileId)
              file.setParent(self)
              generalConfig = self.getParent()
              # the File class should have a parent
              if typeof generalConfig == 'undefined' || generalConfig == null
                cb(new Error('There is no GeneralConfiguration parent on the Module object (you should call Module::setParent if you are using this class manualy)')); cb = ->
                return
          self.addChild(file, (err) ->
            try
              extension = path.extname(fileId)

              # set a default path for extension if there is nothing in the file
              # example : {'.js':'/js', '.css':'/css'} 
              if !(content.pathList[extension])
                content.pathList[extension] = "/#{extension.replace('.','')}"
              pathExtension = content.pathList[extension]

              generalConfig = self.getParent()
              jelly = generalConfig.getParent()

              # there is no Jelly parent on top of the hierarchy
              if jelly == null || typeof jelly == 'undefined'
                cb(new Error('There is no jelly parent on the file (file.getParent().getParent() == null), you should call GeneralConfiguration::setParent() if you are using this class manualy')); cb = ->
                return
              if self.getId() == null
                cb(new Error("The module needs to have an Id to load a file, please call Module::setId() if you are using this class manualy"))
                return
              fileLocation =  "#{jelly.getApplicationDirectory()}/#{self.getId()}/#{pathExtension}/#{fileId}"
              file.loadFromFilename(fileLocation, (err) ->
                cb(err); cb = ->
              )
            catch e
              cb(e); cb = ->
          )
        catch e
          cb(e); cb = ->
      , (err) ->
        cb(err); cb = ->
      )
    catch e
      cb(e); cb = ->;
      return


module.exports = Module # export the class