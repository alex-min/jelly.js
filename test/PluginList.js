// Generated by CoffeeScript 1.6.2
var PluginDirectory, PluginHandler, assert, async, path, toType;

assert = require('chai').assert;

async = require('async');

path = require('path');

toType = function(obj) {
  return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
};

PluginDirectory = require('../src/PluginDirectory');

PluginHandler = require('../src/PluginHandler');

describe('PluginList', function() {
  var PluginList;

  PluginList = require('../src/PluginList');
  describe('#constructor', function() {
    it('creating an instance should not throw errors', function() {
      return new PluginList();
    });
    it('Should extends from a Logger', function() {
      return assert.equal(PluginList.prototype.Logger, true);
    });
    it('Should extends from a ReadableEntity', function() {
      return assert.equal(PluginList.prototype.ReadableEntity, true);
    });
    return it('Should extends from a TreeElement', function() {
      return assert.equal(PluginList.prototype.TreeElement, true);
    });
  });
  return describe('#getPluginHandlerById', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(PluginList.prototype.getPluginHandlerById, 'function');
    });
    it('Should return null when null is passed as an id', function() {
      var dir, handler, p, plug, res;

      dir = new PluginDirectory();
      handler = new PluginHandler();
      handler.setParent(dir);
      dir.addChild(handler);
      p = new PluginList();
      handler.setParent(p);
      p.addChild(handler);
      plug = new PluginList();
      plug.addChild(dir);
      dir.setParent(p);
      res = plug.getPluginHandlerById(null);
      return assert.equal(res, null);
    });
    it('Should return the plugin handler by its id', function() {
      var dir, handler, p, plug, res;

      dir = new PluginDirectory();
      handler = new PluginHandler();
      handler.setParent(dir);
      handler.setId('HandlerID');
      dir.addChild(handler);
      p = new PluginList();
      handler.setParent(p);
      p.addChild(handler);
      plug = new PluginList();
      plug.addChild(dir);
      dir.setParent(p);
      res = plug.getPluginHandlerById('HandlerID');
      assert.typeOf(res, 'object');
      return assert.equal(res.PluginHandler, true);
    });
    return it('Should return null if nothing is found', function() {
      var dir, handler, p, plug, res;

      dir = new PluginDirectory();
      handler = new PluginHandler();
      handler.setParent(dir);
      handler.setId('OtherID');
      dir.addChild(handler);
      p = new PluginList();
      handler.setParent(p);
      p.addChild(handler);
      plug = new PluginList();
      plug.addChild(dir);
      dir.setParent(p);
      res = plug.getPluginHandlerById('HandlerID');
      return assert.equal(res, null);
    });
  });
});