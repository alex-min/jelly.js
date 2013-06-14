winston = require('winston')

class WinstonLoggerWrapper
  _constructor_:->
    @_logger = new (winston.Logger)() ## creating a logger instance
    @_logger.add(winston.transports.Console) ## adding console display  
    @_name = ''

  constructor: -> @_constructor_()
  
  LoggerWrapper: true

  setClassName: (name) -> @_name = name

  info: (s) ->@_logger.info((@_name || '') + ': ' + s)
  log: (type,s) -> @_logger.log(type, (@_name || '') + ': ' + s)
  error: (s) -> @_logger.error((@_name || '') + ': ' + s)
  warn: (s) -> @_logger.warn((@_name || '') + ': ' + s)

  off: -> @_logger.remove()

  addFile: (filepath) ->
    @_logger.add(winston.transports.File, {
      filename: filepath,
      handleExceptions: true
    })



###*
 * The logger class is providing a small interface to add logging capabilites to a given class
 * 
 * @class Logger
###
class Logger
  Logger: true
  _constructor_: ->
    @_log = new WinstonLoggerWrapper()
    @_log.setClassName(@_selfClassName)

  constructor: -> @_constructor_()

  ###*
   * Get the logger class for external usage
   *
   * @for Logger
   * @method getLogger
   * @return {Logger} Logger class object
  ###
  getLogger: ->
    
    @_log


module.exports = Logger # export the class