fs = require('fs')
async = require('async')

GeneralConfiguration = require('./GeneralConfiguration')
Logger = require('./Logger')
Tools = require('./Tools')
ReadableEntity = require('./ReadableEntity')

###*
 * Jelly is the main class of the framework
 * 
 * @class Jelly
###
# inherits from Logger and ReadableEntity
Jelly = Tools.implementing Logger, ReadableEntity, class _Jelly
class Jelly
  constructor: ->
    @getLogger().info('Jelly: Creating a new instance.')
    @_rootDirectory = __dirname
  
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
                    cb(new Error(err), null); cb = -> # do not call the callback twice
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
      rootdir = @getRootDirectory()
      confDir = "#{rootdir}/conf"
      ## check if /conf is a good directory
      @checkRootDirectory((err) ->
        try
          if err
            cb(new Error(err), null); cb = -> # do not call the callback twice
            return
            # read the configuration file
          self.updateContentFromFile("#{confDir}/JellyConf.json", 'utf8', (err, res) ->
            if err?
              cb(new Error(err), null); cb = ->
              return
            cb(null, res); cb = ->;
          )
        catch e
          cb(e, null); cb = ->
      )
    catch e
      cb(e, null); cb = ->

  readAllGeneralConfigurationFiles: (cb) ->
    ## TODO : This method will read all the general configuration files

Tools.include(Jelly, ReadableEntity)

module.exports = Jelly # export the class
