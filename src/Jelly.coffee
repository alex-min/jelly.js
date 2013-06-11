fs = require('fs')
async = require('async')

GeneralConfiguration = require('./GeneralConfiguration')
Logger = require('./Logger')
Tools = require('./Tools')
TreeElement = require('./TreeElement')
ReadableEntity = require('./ReadableEntity')

###*
 * Jelly is the main class of the framework
 * 
 * @class Jelly
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
###
# inherits from Logger and ReadableEntity
Jelly = Tools.implementing Logger, ReadableEntity, TreeElement, class _Jelly
class Jelly
  _constructor_: () ->
    @_parentConstructor_()
    @getLogger().info('Creating a new instance.')
    @_rootDirectory = __dirname

  constructor: -> @_constructor_()

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
   * Returns the current root directory
   * Should return __dirname if nothing is set.
   *
   * @for Jelly
   * @method getRootDirectory
   * @return {String} Root directory
  ###  
  getRootDirectory: -> @_rootDirectory

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
   * @param {cb} Callback to fire, parameters : (err), if there is no error, err is null
   * @return {String} Root directory
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
   * read the main configuration file (/conf/JellyConf.json), the is no interpretation yet
   *
   * @for Jelly
   * @method setRootDirectory
   * @return {String} Root directory
  ### 
  readJellyConfigurationFile: (cb) ->
    self = @
    cb = cb || ->
    try # handle unknown errors
      fileLocation = @getLocalPath('/conf/JellyConf.json')

      async.series([
        ## check the root directory
        (cb) -> self.checkRootDirectory((err) -> cb(err,null)),
        ## then read the file
        (cb) ->
          self.updateContentFromFile(fileLocation, 'utf8', (err, res) ->
            cb(err, res)
          )
        ## then interpret the file
        (cb) -> self.updateAndExecuteCurrentContent((err) -> cb(err))
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

  readConfigurationFile: (cb) ->


    ## TODO : This method will read all the general configuration files


module.exports = Jelly # export the class
