winston = require('winston')

class WinstonLoggerWrapper
  constructor: ->
    @_logger = new (winston.Logger)() ## creating a logger instance
    @_logger.add(winston.transports.Console) ## adding console display
  
  LoggerWrapper: true

  info: (s) -> @_logger.info(s)
  log: (type,s) -> @_logger.log(type,s)
  error: (s) -> @_logger.error(s)
  warn: (s) -> @_logger.warn(s)

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
  constructor: ->
    @_log = new WinstonLoggerWrapper()

  ###*
   * Get the logger class for external usage
   *
   * @for Logger
   * @method getLogger
   * @return {Logger} Logger class object
  ###
  getLogger: ->
    ## due to a bug in coffeescript sometimes, the constructor is not call with inheritance
    if typeof @_log == 'undefined'
      @_log = new WinstonLoggerWrapper()
    @_log

  Logger: true

module.exports = Logger # export the class