// Generated by CoffeeScript 1.6.2
var app, express;

express = require('express');

app = express();

module.exports = {
  load: function(cb) {
    this.getSharedObjectManager().registerObject('httpserver', 'server', app);
    return cb();
  },
  oncall: function(onj, params, cb) {
    app.listen(params.port || 80);
    return cb();
  },
  unload: function(cb) {
    return cb();
  }
};
