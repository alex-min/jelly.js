GeneralConfiguration = require('./GeneralConfiguration')
Logger = require('./Logger')

###*
 * Jelly is the main class of the framework
 * 
 * @class Jelly
###
class Jelly extends Logger
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

  readAllGeneralConfigurationFiles: ->
    ## TODO : This method will read all the general configuration files


module.exports = Jelly # export the class
