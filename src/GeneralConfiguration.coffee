path = require('path')

async = require('async')

ReadableEntity = require('./ReadableEntity')
Tools = require('./Tools')
TreeElement = require('./TreeElement')
Logger = require('./Logger')
Module = require('./Module')

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
    @_parentConstructor_()

  # set default values for the general configuration file
  _setDefaultContent: (content) ->
    content.name ?= path.basename(@getId(), '.json')
    content.moduleConfigurationFilename ?= 'assets.json'
    content.plugins ?= []
    content.pluginParameters ?= {}
    content.loadedModules ?= []

  ###*
   * Load a general configuration from its configuration file
   * This method must be called once when loading the general configuration for the first time.
   * After this, only calls to the 'reload' method are allowed.
   *
   * @for GeneralConfiguration
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
            self.reload(cb); cb = ->
        catch e
          cb(e); cb = ->
      )
    catch e
      cb(e)

  ###*
   * Do the necessary calls to reload the general configuration (it must be loaded before calling this)
   * Currently equivalent to the readAllFiles method 
   *
   * @for GeneralConfiguration
   * @method reload
   * @param {Function} callback : parameters (err : error occured) 
  ###
  reload: (cb) ->@readAllModules(cb)

  ###*
   * load all the module (this method is reading all modules recursively)
   * The 'loadedModules' array on the general configuration file is used to determine the list of modules to load.
   * This method is also triggering the 'readAllFiles' method on each module
   *
   * @for GeneralConfiguration
   * @method readAllModules
   * @param {Function} callback : parameters (err : error occured) 
  ###
  readAllModules: (cb) ->
    self = @
    cb = cb || ->
    # we gather the last executable content to get what module to load
    content = @getLastExecutableContent()
    if content == null
      cb(new Error('There is no executable content pushed on the GeneralConfiguration Class')); cb = ->;
      return
    @_setDefaultContent(content) # set default values for the general configuration file
    
    # for each module in the LoadedModules entry
    async.map(content.loadedModules, (moduleName, cb) ->
      # we get the module name
      module = self.getChildById(moduleName)
      async.series([
            (cb) ->
              # if the module is not loaded yet, we load it
              if module == null
                try
                  module = new Module()
                  module.setId(moduleName.name)
                  module.setParent(self)
                  jelly = self.getParent()
                  if typeof jelly == 'undefined' || jelly == null
                    cb(new Error('There is no Jelly parent on the GeneralConfiguration object (you should call GeneralConfiguration::setParent if you are using this class manualy)')); cb = ->
                    return
                  moduledir = jelly.getLocalPath("app/#{moduleName.name}/#{content.moduleConfigurationFilename}")
                  self.addChild(module, (err) ->
                    if err
                      cb(err); cb = ->
                      return
                    module.loadFromFilename(moduledir,(err) ->
                      cb(err)
                    )
                  )
                catch e
                  cb(e)
              else
                cb()
          , (cb) -> cb(null)
        ]
      , (err) ->
        cb(err)
      )
    , (err) -> cb(err)
    )
    

module.exports = GeneralConfiguration # export the class