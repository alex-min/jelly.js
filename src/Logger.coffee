winston = require('winston')

class WinstonLoggerWrapper
  _constructor_:->
    @_logger = new (winston.Logger)() ## creating a logger instance
    @_logger.add(winston.transports.Console) ## adding console display  

  constructor: -> @_constructor_()
  
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
  _constructor_: ->
    @_log = new WinstonLoggerWrapper()

  constructor: -> @_constructor_()

  ###*
   * Get the logger class for external usage
   *
   * @for Logger
   * @method getLogger
   * @return {Logger} Logger class object
  ###
  getLogger: -> @_log

  Logger: true

module.exports = Logger # export the class