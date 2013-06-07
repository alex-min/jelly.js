path = require('path')

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
    @_parentConstructor_()

  _setDefaultContent: (content) ->
    content.name ?= path.basename(@getId(), '.json')
    content.moduleConfigurationFilename ?= 'assets.json'
    content.plugins ?= []
    content.pluginParameters ?= {}
    content.loadedModules ?= []

  readAllModules: (cb) ->
    cb = cb || ->

    content = @getLastExecutableContent()
    if content == null
      cb(new Error('There is no executable content pushed on the Module Class')); cb = ->;
      return
    @_setDefaultContent(content)
    cb()    

module.exports = GeneralConfiguration # export the class