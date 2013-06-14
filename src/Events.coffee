events = require('events')


###*
 * Events is a class to deal with node's Events api
 * The main goal of this class is to provide listeners and emitters with events
 * 
 * @class Events
###
class Events extends events.EventEmitter
  constructor: -> @_constructor_()
  _constructor_:->

module.exports = Events # export the class