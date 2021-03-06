// Generated by CoffeeScript 1.6.2
var File, GeneralConfiguration, Jelly, Module, PluginHandler, ReadableEntity, SharedObjectManager, Tools, TreeElement, assert, async, path, toType;

assert = require('chai').assert;

async = require('async');

path = require('path');

toType = function(obj) {
  return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
};

File = require('../src/File');

Module = require('../src/Module');

PluginHandler = require('../src/PluginHandler');

Tools = require('../src/Tools');

ReadableEntity = require('../src/ReadableEntity');

TreeElement = require('../src/TreeElement');

GeneralConfiguration = require('../src/GeneralConfiguration');

Jelly = require('../src/Jelly');

SharedObjectManager = require('../src/SharedObjectManager');

describe('SharedObjectManager', function() {
  describe('#constructor', function() {
    return it('creating an instance should not throw errors', function() {
      var sharedObjectManager;

      return sharedObjectManager = new SharedObjectManager();
    });
  });
  describe('#registerObject', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(SharedObjectManager.prototype.registerObject, 'function');
    });
    return it('Should register content', function() {
      var obj, sharedObject;

      sharedObject = new SharedObjectManager();
      sharedObject.registerObject('A', 'B', 'TEST');
      obj = sharedObject.getObject('A', 'B');
      assert.equal(toType(obj), 'object');
      assert.equal(obj.SharedObject, true);
      assert.equal(obj.getCurrentContent(), 'TEST');
      sharedObject.registerObject('A', 'B', 'TEST2');
      return assert.equal(obj.getCurrentContent(), 'TEST2');
    });
  });
  return describe('#getObject', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(SharedObjectManager.prototype.getObject, 'function');
    });
    return it('Should return null when there is no object bound', function() {
      return assert.equal(new SharedObjectManager().getObject(), null);
    });
  });
});
