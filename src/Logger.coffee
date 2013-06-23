winston = require('winston')

class WinstonLoggerWrapper
  _constructor_:->
    @_logger = new (winston.Logger)() ## creating a logger instance
    @_logger.add(winston.transports.Console) ## adding console display  
    @_name = ''
    @_object = null

  constructor: -> @_constructor_()
  
  LoggerWrapper: true

  setClassName: (name) -> @_name = name

  setObject: (obj) ->
    @_object = obj


  getPrintHeader: ->
    id = ''
    if @_object? and typeof @_object.getId == 'function' and @_object.getId() != null
      id = '[' + @_object.getId() + ']'
    return (@_name || '') + id + ': '

  info: (s) ->@_logger.info(@getPrintHeader() + s)
  log: (type,s) -> @_logger.log(type, @getPrintHeader() + s)
  error: (s) -> @_logger.error(@getPrintHeader() + s)
  warn: (s) -> @_logger.warn(@getPrintHeader() + s)

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
    @_log.setObject(this)

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