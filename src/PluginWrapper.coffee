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

  applyPlugin: (pluginInterface, cb) ->
    cb = cb || ->
    self = @

    # check if the pluginInterface is valid
    if typeof pluginInterface == 'undefined' || \
      pluginInterface == null || \
      pluginInterface.PluginInterface != true
        cb(new Error("Unable to apply plugin : Invalid pluginInterface passed as a parameter")); cb = ->
        return
    cb()



module.exports = PluginWrapper # export the class

