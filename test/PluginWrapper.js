// Generated by CoffeeScript 1.6.2
var File, Module, PluginHandler, ReadableEntity, Tools, TreeElement, assert, async, path, toType;

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

describe('PluginWrapper', function() {
  var PluginWrapper;

  PluginWrapper = require('../src/PluginWrapper');
  it('Should be a PluginWrapper', function() {
    return assert.equal(PluginWrapper.prototype.PluginWrapper, true);
  });
  describe('_constructor_', function() {
    return it('Should have a _constructor_', function() {
      return assert.typeOf(PluginWrapper.prototype._constructor_, 'function');
    });
  });
  describe('constructor', function() {
    return it('Should raise no error when creating a new instance', function() {
      return new PluginWrapper();
    });
  });
  describe('#getPluginList', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(PluginWrapper.prototype.getPluginList, 'function');
    });
    it('Should raise an error when the object is not inherited from a TreeElement', function(cb) {
      var A, _A;

      A = Tools.implementing(ReadableEntity, PluginWrapper, _A = (function() {
        function _A() {}

        return _A;

      })(), A = (function() {
        A.prototype._constructor_ = function() {
          return this._parentConstructor_();
        };

        function A() {
          this._constructor_();
        }

        return A;

      })());
      return new PluginWrapper().getPluginList(function(err) {
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
    it('Should raise an error when the object is not inherited from a ReadableEntity', function(cb) {
      var A, _A;

      A = Tools.implementing(TreeElement, PluginWrapper, _A = (function() {
        function _A() {}

        return _A;

      })(), A = (function() {
        A.prototype._constructor_ = function() {
          return this._parentConstructor_();
        };

        function A() {
          this._constructor_();
        }

        return A;

      })());
      return new PluginWrapper().getPluginList(function(err) {
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
    it('Should raise an error when there is no content', function(cb) {
      return new PluginDirectory().getPluginListFromObject(new Module(), function(err) {
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
    it('Should return an empty array when there is no plugins', function(cb) {
      var m;

      m = new Module();
      m.updateContent({
        content: {},
        extension: '__exec'
      });
      return new PluginDirectory().getPluginListFromObject(m, function(err, list) {
        var e;

        if (err != null) {
          cb(err);
          cb = function() {};
          return;
        }
        try {
          assert.typeOf(list, 'array');
          assert.equal(list.length, 0);
          return cb();
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
    it('Should raise an error when the file has no parent', function(cb) {
      var f;

      f = new File();
      f.updateContent({
        content: {},
        extension: '__exec'
      });
      return new PluginDirectory().getPluginListFromObject(f, function(err) {
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
    it('Should raise an error when the file has a parent module with no content', function(cb) {
      var f, m;

      f = new File();
      f.updateContent({
        content: {},
        extension: '__exec'
      });
      m = new Module();
      m.addChild(f);
      f.setParent(m);
      return new PluginDirectory().getPluginListFromObject(f, function(err) {
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
    it('Should return an empty array when there is no plugins (on File objects)', function(cb) {
      var f, m;

      f = new File();
      f.updateContent({
        content: {},
        extension: '__exec'
      });
      m = new Module();
      m.addChild(f);
      m.updateContent({
        content: {},
        extension: '__exec'
      });
      f.setParent(m);
      return new PluginDirectory().getPluginListFromObject(f, function(err, list) {
        var e;

        if (err != null) {
          cb(err);
          cb = function() {};
          return;
        }
        try {
          assert.typeOf(list, 'array');
          assert.equal(list.length, 0);
          return cb();
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
    it('Should return the plugin list (on File objects)', function(cb) {
      var f, m;

      f = new File();
      f.updateContent({
        content: {},
        extension: '__exec'
      });
      m = new Module();
      m.addChild(f);
      m.updateContent({
        content: {
          plugins: ['hello'],
          filePlugins: ['world']
        },
        extension: '__exec'
      });
      f.setParent(m);
      return new PluginDirectory().getPluginListFromObject(f, function(err, list) {
        var e;

        if (err != null) {
          cb(err);
          cb = function() {};
          return;
        }
        try {
          assert.typeOf(list, 'array');
          assert.equal(list.length, 1);
          assert.equal(list[0], 'world');
          return cb();
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
    return it('Should return the plugin list (on File objects)', function(cb) {
      var m;

      m = new Module();
      m.updateContent({
        content: {
          plugins: ['hello'],
          filePlugins: ['world']
        },
        extension: '__exec'
      });
      return new PluginDirectory().getPluginListFromObject(m, function(err, list) {
        var e;

        if (err != null) {
          cb(err);
          cb = function() {};
          return;
        }
        try {
          assert.typeOf(list, 'array');
          assert.equal(list.length, 1);
          assert.equal(list[0], 'hello');
          return cb();
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
  });
  return describe('applyPlugin', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(PluginWrapper.prototype.applyPlugin, 'function');
    });
    it('Should raise an error when the plugin is invalid', function(cb) {
      return new PluginWrapper().applyPlugin({}, function(err) {
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
    it('Should raise an error when the plugin is invalid', function(cb) {
      return new PluginWrapper().applyPlugin({}, function(err) {
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
    it('Should be used only on a class extending from ReadableEntity', function(cb) {
      var p;

      p = new PluginWrapper();
      p.PluginHandler = true;
      return p.applyPlugin(p, function(err) {
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
    it('Should raise an error when used with a File with no parent', function(cb) {
      var file, p;

      p = new PluginHandler();
      file = new File();
      return file.applyPlugin(p, function(err) {
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
    it('Should raise an error when used with a File with a parent module with no content', function(cb) {
      var file, module, p;

      p = new PluginHandler();
      file = new File();
      module = new Module();
      file.setParent(module);
      return file.applyPlugin(p, function(err) {
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
    it('Should apply the plugin to a File instance', function(cb) {
      var emptyFile, file, module, p, pluginInterface;

      p = new PluginHandler();
      p.setId('plugin');
      file = new File();
      module = new Module();
      file.setParent(module);
      emptyFile = {
        content: {},
        extension: '__exec'
      };
      module.updateContent(emptyFile);
      p.updateContent(emptyFile);
      pluginInterface = p.getPluginInterface();
      pluginInterface.updateContent({
        content: {
          oncall: function(obj, param, cb) {
            console.log('TEST:ONCALL fired !');
            return cb();
          }
        },
        extension: '__exec'
      });
      return file.applyPlugin(p, function(err) {
        return cb(err);
      });
    });
    it('Should raise an error when there is no content', function(cb) {
      var module, p;

      p = new PluginHandler();
      module = new Module();
      return module.applyPlugin(p, function(err) {
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
    it('Should raise an error when the pluginHandler does not have an id set', function(cb) {
      var emptyFile, file, module, p, pluginInterface;

      p = new PluginHandler();
      file = new File();
      module = new Module();
      file.setParent(module);
      emptyFile = {
        content: {},
        extension: '__exec'
      };
      module.updateContent(emptyFile);
      p.updateContent(emptyFile);
      pluginInterface = p.getPluginInterface();
      pluginInterface.updateContent({
        content: {
          oncall: function(obj, param, cb) {
            return cb();
          }
        },
        extension: '__exec'
      });
      return file.applyPlugin(p, function(err) {
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
    it('Should set an empty array as pluginParameters by default on a File instance', function(cb) {
      var emptyFile, file, module, p, pluginInterface;

      p = new PluginHandler();
      p.setId('plugin');
      file = new File();
      module = new Module();
      file.setParent(module);
      emptyFile = {
        content: {},
        extension: '__exec'
      };
      module.updateContent(emptyFile);
      p.updateContent(emptyFile);
      pluginInterface = p.getPluginInterface();
      pluginInterface.updateContent({
        content: {
          oncall: function(obj, param, cb) {
            var e;

            try {
              assert.typeOf(param, 'object');
              assert.equal(toType(param.pluginParameters), 'object');
              assert.equal(JSON.stringify(param.pluginParameters), '{}');
              return cb();
            } catch (_error) {
              e = _error;
              return cb(e);
            }
          }
        },
        extension: '__exec'
      });
      return file.applyPlugin(p, function(err) {
        return cb(err);
      });
    });
    return it('Should set an empty array as pluginParameters by default on a Other instances', function(cb) {
      var emptyFile, module, p, pluginInterface;

      p = new PluginHandler();
      p.setId('plugin');
      module = new Module();
      emptyFile = {
        content: {},
        extension: '__exec'
      };
      module.updateContent(emptyFile);
      p.updateContent(emptyFile);
      pluginInterface = p.getPluginInterface();
      pluginInterface.updateContent({
        content: {
          oncall: function(obj, param, cb) {
            var e;

            try {
              assert.typeOf(param, 'object');
              assert.equal(toType(param.pluginParameters), 'object');
              assert.equal(JSON.stringify(param.pluginParameters), '{}');
              return cb();
            } catch (_error) {
              e = _error;
              return cb(e);
            }
          }
        },
        extension: '__exec'
      });
      return module.applyPlugin(p, function(err) {
        return cb(err);
      });
    });
  });
});
