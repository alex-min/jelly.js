// Generated by CoffeeScript 1.6.2
var GeneralConfiguration, Jelly, assert, async, path, toType;

assert = require('chai').assert;

async = require('async');

path = require('path');

toType = function(obj) {
  return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
};

Jelly = require('../src/Jelly');

GeneralConfiguration = require('../src/GeneralConfiguration');

describe('PluginHandler', function() {
  var PluginHandler;

  PluginHandler = require('../src/PluginHandler');
  it('Should be a PluginHandler', function() {
    return assert.equal(PluginHandler.prototype.PluginHandler, true);
  });
  describe('_constructor_', function() {
    return it('Should have a _constructor_', function() {
      return assert.typeOf(PluginHandler.prototype._constructor_, 'function');
    });
  });
  return describe('#readConfigFile', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(PluginHandler.prototype.readConfigFile, 'function');
    });
    return it('Should raise an error when there is no directory bound to the PluginHandler', function(cb) {
      return new PluginHandler().readConfigFile(function(err) {
        var e;

        try {
          assert.equal(toType(err), 'error');
          return cb();
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
  });
});
