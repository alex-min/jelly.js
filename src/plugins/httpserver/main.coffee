express = require('express')
app = express()

module.exports = {
  load: (cb) ->
    @getSharedObjectManager().registerObject('httpserver', 'server', app)
    cb()
  oncall: (onj, params, cb) ->
    cb()
  unload: (cb) ->
    cb()
}