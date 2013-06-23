async = require('async')
fs = require('fs')

Tools = require('./Tools')
Logger = require('./Logger')
ReadableEntity = require('./ReadableEntity')
TreeElement = require('./TreeElement')
File = require('./File')
PluginHandler = require('./PluginHandler')

###*
 * PluginWrapper is a class providing plugin capabilities to another class.
 * Jelly, GeneralConfiguration, Module and File are inheriting from it. 
 * 
 * @class PluginWrapper
###
class PluginWrapper
  PluginWrapper: true
  _constructor_: ->;
  constructor: -> @_constructor_()

  # applying a plugin for a File class.
  # Do NOT call this method from outside the class. 
  _applyPluginFile: (pluginHandler, cb) ->
      # get parent module
      module = @getParent()
      if module == null or typeof module == 'undefined'
        cb(new Error("The specified File '#{@getId()}' does not have a parent module")); cb = ->
        return
      # get the configuration for the parent module (which also have the file configuration)
      config = module.getLastExecutableContent()
      # the module configuration file must be loaded
      if config == null
        cb(new Error("There is no config file read on the parent module of the File '#{@getId()}'")); cb = ->
        return
      config.filePluginParameters ?= []
      config.filePluginParameters[pluginHandler.getId()] = {}
      # calling the plugin with the pluginParameters
      pluginHandler.getPluginInterface().oncall(this,
      {
        pluginParameters:config.filePluginParameters[pluginHandler.getId()]
      },cb)    


  # applying a plugin for other type exept the File class.
  # Do NOT call this method from outside the class. 
  _applyPluginOtherClass: (pluginHandler, cb) ->
      self = @

      # get the configuration
      config = self.getLastExecutableContent()

      # the configuration file must be loaded
      if config == null
        cb(new Error("There is no config file loaded for the Id '#{self.getId()}' on a #{self.constructor.name} object")); cb = ->
        return

      config.filePluginParameters ?= []
      config.filePluginParameters[pluginHandler.getId()] = {}
      # calling the plugin with the plugin parameters
      pluginHandler.getPluginInterface().oncall(self,
      {
        plugins:config.plugins
        pluginParameters:config.filePluginParameters[pluginHandler.getId()]
      },cb)    

  ###*
   * Find and apply all the plugins defined in the cofiguration file.
   *
   * @for PluginWrapper
   * @method applyPluginsSpecified
   * @aync
   * @param {Boolean} [recursive] Applying plugins on all childs (Default : false).
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  applyPluginsSpecified: (recursive, cb) ->
    cb = cb || ->
    self = @

    # recursive is an optional parameter
    if typeof recursive == 'function'
      cb = recursive
      # false is the default value for the recursive mode      
      recursive = false
    # recursive MUST be boolean
    if typeof recursive != 'boolean'
      cb(new Error("Invalid non-boolean parameter passed as 'recursive' : #{recursive}")); cb = ->
      return

    # this should extends from a TreeElement
    if Object.getPrototypeOf(this).TreeElement != true
      cb(new Error('The object must inherit from a TreeElement to use PluginWrapper::applyPluginsSpecified')); cb = ->
      return

    # get the Jelly root parent class
    jelly = @getParentOfClass('Jelly')
    if jelly == null
      cb(new Error("There is no Jelly parent on Id '#{@getId()}'.")); cb = ->
      return

    # retrive the plugin directory 
    pluginDirectory = jelly.getPluginDirectoryList()
    if pluginDirectory == null || typeof pluginDirectory == 'undefined'
      cb(new Error('There is no pluginDirectory instance bound to the Jelly instance')); cb = ->
      return

    async.waterfall([
      (cb) ->
        # get the plugin list as string
        self.getPluginList(cb)
      (list, cb) ->
        # get the plugin list as {PluginHandler}
        pluginDirectory.getPluginListFromIdList(list, cb)
      (plugins, cb) ->
        # for each plugins
        async.map(plugins, (plugin, cb) ->
          # we apply each plugin to the current class
          self.applyPlugin(plugin, cb)
        , (err) ->
          cb(err)
        )
    ], (err) ->
      if err?
        cb(err); cb = ->
        return
      # if its recursive, call the method again for all the childs
      if recursive
        # for each child
        async.map(self.getChildList(), (child, cb) ->
          # apply the plugins on each child
          child.applyPluginsSpecified(true, cb)
        , (err) ->
          cb(err); cb = ->
        )
      else
        cb(); cb = ->
    )

  ###*
   * Apply a plugin to the current class (this). Only for class which extends from a PluginWrapper.
   *
   * @for PluginWrapper
   * @method applyPlugin
   * @aync
   * @param {PluginHandler} The plugin to apply to the class
   * @param {String} filename The location of the file
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  applyPlugin: (pluginHandler, cb) ->
    cb = cb || ->
    self = @

    # check if the pluginInterface is valid
    if typeof pluginHandler == 'undefined' || \
      pluginHandler == null || \
      pluginHandler.PluginHandler != true
        cb(new Error("Unable to apply plugin : Invalid pluginHandler passed as a parameter")); cb = ->
        return

    # check if the class inherits from a ReadableEntity class
    if self.ReadableEntity != true
      cb(new Error("Unable to apply plugin : The class must inherit from ReadableEntity to use this method"))
      return

    # the plugin does not have any Id
    if pluginHandler.getId() == null
      cb(new Error("The pluginHandler must have an ID to be applied.")); cb = ->
      return

    # specific case for the File class which does not have its own configuration file
    if self.File == true
      @_applyPluginFile(pluginHandler, cb)
    else # for all the other types of classes (Module, Jelly, GeneralConfiguration)
      @_applyPluginOtherClass(pluginHandler, cb)

  ###*
   * Get the list of plugins to apply to a particular class.
   * This method will read the entry 'plugins' on the last executable content of the class.
   * For a File instance, the parent module will be used instead.
   * This method does not load anything.
   *
   * @for PluginWrapper
   * @method getPluginList
   * @aync
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
   * @param {String[]} callback.pluginList The plugin list (as an array of string)   
  ###
  getPluginList: (cb) ->
    cb = cb || ->
    object = this
    errormsg = 'Unable to get the plugin list'

    try

      ## ... a lot of checks ... 

      # it must extend from a TreeElement
      if typeof Object.getPrototypeOf(object).TreeElement == 'undefined'
        cb(new Error("#{errormsg}: The object must extend from a TreeElement"), null)
        return

      # and also from a ReadableEntity
      if Object.getPrototypeOf(object).ReadableEntity != true
        cb(new Error("#{errormsg}: The object must extend from a ReadableEntity"), null); cb = ->
        return

      # check if the content is null exept for a File class which have a different treatment
      content = object.getLastExecutableContent()
      if content == null && typeof object.File == 'undefined'
        cb(new Error("#{errormsg} on #{object.getId()}: There is no content loaded"), null); cb = ->
        return

      if typeof Object.getPrototypeOf(object).File != 'undefined'
        parent = object.getParent()
        # the file must have a parent module to apply plugins
        if parent == null
          cb(new Error("#{errormsg} on File '#{object.getId()}', There is no parent module bound to the class"), null); cb = ->
          return
        content = parent.getLastExecutableContent()
        # the module must have a content loaded
        if content == null
          cb(new Error("#{errormsg} on File '#{object.getId()}', There is no content on the parent module."), null); cb = ->
          return
        # an empty array is the default for the plugin list
        cb(null, content.filePlugins || []); cb = ->
      else
        # an empty array is the default for the plugin list
        cb(null, content.plugins || []); cb = ->
    catch e
      cb(e); cb = ->

module.exports = PluginWrapper # export the class

