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

describe('PluginInterface', function() {
  var PluginInterface;

  PluginInterface = require('../src/PluginInterface');
  it('Should be a PluginInterface', function() {
    return assert.equal(PluginInterface.prototype.PluginInterface, true);
  });
  describe('_constructor_', function() {
    return it('Should have a _constructor_', function() {
      return assert.typeOf(PluginInterface.prototype._constructor_, 'function');
    });
  });
  describe('::STATUS', function() {
    it('Should exist', function() {
      return assert.typeOf(PluginInterface.prototype.STATUS, 'object');
    });
    return it('Should contain the status', function() {
      assert.equal(PluginInterface.prototype.STATUS.NOT_LOADED, 0);
      return assert.equal(PluginInterface.prototype.STATUS.LOADED, 1);
    });
  });
  describe('#constructor', function() {
    it('creating an instance should not throw errors', function() {
      var pluginInterface;

      return pluginInterface = new PluginInterface();
    });
    it('Should extends from a Logger', function() {
      return assert.equal(PluginInterface.prototype.Logger, true);
    });
    it('Should extends from a ReadableEntity', function() {
      return assert.equal(PluginInterface.prototype.ReadableEntity, true);
    });
    return it('Should extends from a TreeElement', function() {
      return assert.equal(PluginInterface.prototype.TreeElement, true);
    });
  });
  describe('#unload', function() {
    return it('Should be a callable function', function() {
      return assert.typeOf(PluginInterface.prototype.unload, 'function');
    });
  });
  return describe('#getStatus', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(PluginInterface.prototype.getStatus, 'function');
    });
    it('Should return NOT_LOADED by default', function() {
      return assert.equal(new PluginInterface().getStatus(), PluginInterface.prototype.STATUS.NOT_LOADED);
    });
    return it('Should set to LOADED if we load the plugin and NOT_LOADED if we unload the plugin', function(cb) {
      var p;

      p = new PluginInterface();
      p.updateContent({
        content: {
          load: function(cb) {
            return cb();
          },
          unload: function(cb) {
            return cb();
          }
        },
        extension: '__exec'
      });
      return p.load(function() {
        var e;

        try {
          assert.equal(p.getStatus(), PluginInterface.prototype.STATUS.LOADED);
          return p.unload(function() {
            var e;

            try {
              assert.equal(p.getStatus(), PluginInterface.prototype.STATUS.NOT_LOADED);
              cb();
              return cb = function() {};
            } catch (_error) {
              e = _error;
              return cb(e);
            }
          });
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
  });
});