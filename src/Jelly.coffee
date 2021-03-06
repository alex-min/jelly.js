fs = require('fs')
async = require('async')
path = require('path')

GeneralConfiguration = require('./GeneralConfiguration')
Logger = require('./Logger')
Tools = require('./Tools')
TreeElement = require('./TreeElement')
ReadableEntity = require('./ReadableEntity')
PluginWrapper = require('./PluginWrapper')
PluginDirectory = require('./PluginDirectory')
SharedObjectManager = require('./SharedObjectManager')

###*
 * Jelly is the main class of the framework
 * 
 * @class Jelly
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
# inherits from Logger and ReadableEntity
Jelly = Tools.implementing PluginWrapper, Logger, ReadableEntity, TreeElement, class _Jelly
class Jelly
  _constructor_: () ->
    @_parentConstructor_()
    @getLogger().info('Creating a new instance.')
    @_rootDirectory = __dirname
    @_pluginDirectoryList = new PluginDirectory()
    @_pluginDirectoryList.setParent(this)
    @_sharedObjectManager = new SharedObjectManager()
    @setId('Jelly')

  constructor: -> @_constructor_()

  ## TODO: TESTS + DOC
  getEntityListFromIdList: (idlist) ->
    if typeof idlist == 'undefined' || idlist == null || Tools.toType(idlist) != 'array'
      return []
    ret = []
    for id in idlist
      child = @getChildByIdRec(id)
      continue if child == null || typeof child == 'undefined'
      ret.push(child)
    return ret

  ## TODO : DOC
  boot: (options={}, cb) ->
    self = @
    options.packagePlugins ?= []
    options.folderPlugins ?= []
    options.onBeforeApplyPlugins = options.onBeforeApplyPlugins || ((cb) -> cb())

    if typeof options.directory == 'string'
      @setRootDirectory(options.directory)
    async.series([
      (cb) -> self.readJellyConfigurationFile( (err) -> cb(err,null)),
      (cb) -> self.readAllGeneralConfigurationFiles( (err) -> cb(err,null))
      (cb) ->
        async.each(options.packagePlugins, (plugin, cb) ->
          try
            if options.localRequire? && typeof options.localRequire != 'undefined'
              options.localRequire("jellyjs-plugin-#{plugin}", (err, pluginDir) ->
                try
                  if err?
                    cb(err); cb = ->
                    return
                  self.getPluginDirectoryList().readPluginFromPath(path.dirname(pluginDir), plugin, cb)
                catch e
                  cb(e)
              )
            else
              pluginDir = path.dirname(require.resolve("jellyjs-plugin-#{plugin}"))
              self.getPluginDirectoryList().readPluginFromPath(pluginDir, plugin, cb)
          catch e
            cb(new Error("Unable to boot project on Jelly::boot : #{e.message}"))
        cb)
      (cb) ->
        async.each(options.folderPlugins, (plugin, cb) ->
          try
            if typeof plugin.name != 'string' || typeof plugin.directory != 'string'
              cb(new Error("Unable to boot project on Jelly::boot : The plugin #{JSON.stringify(plugin)} should register a name and a directory")); cb = ->
              return
            self.getPluginDirectoryList().readPluginFromPath(plugin.directory, plugin.name, cb)
          catch e
            cb(new Error("Unable to boot project on Jelly::boot : #{e.message}"))
        cb)
      (cb) ->
        try
          options.onBeforeApplyPlugins((err) ->
            cb(err); cb = ->
          )
        catch e
          cb(new Error("Jelly::boot(onBeforeApplyPlugins): #{e.message}")) 
      (cb) ->
        if options.applyPluginsSpecified == false
          cb()
        else
          self.applyPluginsSpecified(true, (err) -> cb(err))
    ], cb)

  ###*
   * Get the path relatiive to the root directory
   * getLocalPath(path) is equivalenent of getRootDirectory() + '/' + path
   *
   * @for Jelly
   * @method getLocalPath
   * @return {String} Local directory
  ###    
  getLocalPath: (path) ->
    return @_rootDirectory + '/' + path.toString()

  ###*
   * Get the {SharedObjectManager} instance associated with the class
   *
   * @for Jelly
   * @method getSharedObjectManager
   * @return {SharedObjectManager} The SharedObjectManager
  ###
  getSharedObjectManager: () ->
    return @_sharedObjectManager

  ###*
   * Get the PluginDirectory instance associated with the class.
   * The PluginDirectory instance is created in the constructor.
   *
   * @for Jelly
   * @method getPluginDirectoryList
   * @return {PluginDirectory} PluginList instance
  ###
  getPluginDirectoryList: -> @_pluginDirectoryList


  ###*
   * Returns the current root directory
   * Should return __dirname if nothing is set.
   *
   * @for Jelly
   * @method getRootDirectory
   * @return {String} Root directory
  ###  
  getRootDirectory: -> @_rootDirectory


  ###*
   * Returns the application folder
   * Should return getRootDirectory() + '/app'.
   * For the moment, the application directory cannot be set and is always under the /app directory.
   *
   * @for Jelly
   * @method getRootDirectory
   * @return {String} Root directory
  ###  
  getApplicationDirectory: -> "#{@_rootDirectory}/app"

  ###*
   * Returns the plugins folder
   * Should return getRootDirectory() + '/plugins'.
   * For the moment, the plugins directory cannot be set and is always under the /plugins directory.
   *
   * @for Jelly
   * @method getPluginDirectory
   * @return {String} Root directory
  ###  
  getPluginDirectory: -> "#{@_rootDirectory}/plugins"

  ###*
   * Sets the current root directory
   *
   * @for Jelly
   * @method setRootDirectory
   * @return {String} Root directory
  ###   
  setRootDirectory: (dir) ->
    @getLogger().info("Jelly: the root directory is now set to #{dir}")
    @_rootDirectory = dir

  ###*
   * Checks if the rootDirectory is valid (and all their subfolders)
   *
   * @for Jelly
   * @method checkRootDirectory
   * @async
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ### 
  checkRootDirectory: (cb) ->
    cb = cb || ->
    root = @_rootDirectory
    async.each([root, "#{root}/conf","#{root}/app"], (dir,cb) ->
        fs.stat(dir, (err,st) ->
                try
                  if err
                    cb(err, null); cb = -> # do not call the callback twice
                    return
                  if !(st.isDirectory())
                    # do not call the callback twice
                    cb(new Error("#{dir} is not a valid directory"), null); cb = ->
                    return
                  cb(null) # the directory is valid
                catch e
                  cb(e, null); cb = ->
        )
    , (err) ->
      cb(err); cb = ->
    )    
  
  ###*
   * Read the main configuration file (/conf/JellyConf.json)
   * This will trigger other methods in this order :
   *    - checkRootDirectory to check if the main directory is valid
   *    - updateContentFromFile to read /conf/JellyConf.json
   *    - updateAndExecuteCurrentContent to interpret the json file to use it on the code
   *    - readAllGeneralConfigurationFiles : if everything is OK, process general configuration files.
   * 
   * @for Jelly
   * @method readJellyConfigurationFile
   * @async
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
   * @param {String} callback.content Content read from the file 
  ### 
  readJellyConfigurationFile: (cb) ->
    self = @
    cb = cb || ->

    try # handle unknown errors
      fileLocation = @getLocalPath('/conf/JellyConf.json')

      async.series([
        ## check the root directory
        (cb) -> self.checkRootDirectory((err) -> cb(err,null)),
        ## then read and interpret the file
        (cb) -> self.readUpdateAndExecute(fileLocation, 'utf8', (err) ->
          content = null
          if err == null
            content = self.getLastContentOfExtension('json')
          cb(err, content)
        )

        ## then process all the general configuration files
        ## this will also process the modules
        (cb) -> self.readAllGeneralConfigurationFiles((err) -> cb(err))
      ], (err, res) ->
        # because the async function is returning an array of results
        # and only updateContentFromFile should return a result 
        res = if res.length >= 2 then res[1] else null
        cb(err,res)
      )
    catch e
      cb(e, null); cb = ->


  readAllGeneralConfigurationFiles: (cb) ->
    self = @

    # check if the file was read
    content = @getLastExecutableContent()
    if content == null
      cb(new Error('There is no executable content pushed on the Jelly Class')); cb = ->;
      return

    # the default is an empty array
    content.listOfConfigurationFiles ?= []
    # read each configuration file specified
    async.map(content.listOfConfigurationFiles, (fileLocation, cb) ->
        fileAbsolutLocation = self.getLocalPath(fileLocation)
        generalConfig = self.getChildById(fileLocation)
        
        async.series([
          # check if this configuration file is already read 
          (cb) ->
            if generalConfig == null # if not, we create it
              generalConfig = new GeneralConfiguration()
              generalConfig.setId(fileLocation)
              generalConfig.setParent(self)
              self.addChild(generalConfig, cb)
            else
              cb()
          # interpret the file
          (cb) -> generalConfig.loadFromFilename(fileAbsolutLocation, cb)
        ], (err) -> 
          cb(err)
        )
      , (err) ->
        cb(err)
    )

  readConfigurationFile: (cb) -> cb()


    ## TODO : This method will read all the general configuration files


module.exports = Jelly # export the class
