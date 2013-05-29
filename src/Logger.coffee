winston = require('winston')

class WinstonLoggerWrapper
  constructor: ->
    @_logger = new (winston.Logger)()
  
  LoggerWrapper: true

  info: (s) -> @_logger.info(s)
  log: (type,s) -> @_logger.log(type,s)
  error: (s) -> @_logger.error(s)
  warn: (s) -> @_logger.warn(s)

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
class Logger extends WinstonLoggerWrapper
  constructor: ->

  Logger: true

module.exports = Logger # export the class