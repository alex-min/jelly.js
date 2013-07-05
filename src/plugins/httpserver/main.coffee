express = require('express')
app = express()

module.exports = {
  load: (cb) ->
    @getSharedObjectManager().registerObject('httpserver', 'server', app)
    cb()
  oncall: (onj, params, cb) ->
    app.listen(params.port || 80)
    cb()
  unload: (cb) ->
    cb()
}