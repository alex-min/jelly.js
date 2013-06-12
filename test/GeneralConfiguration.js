// Generated by CoffeeScript 1.6.2
var Jelly, assert, async, path, toType;

assert = require('chai').assert;

async = require('async');

path = require('path');

toType = function(obj) {
  return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
};

Jelly = require('../src/Jelly');

return;

describe('GeneralConfiguration', function() {
  var GeneralConfiguration;

  GeneralConfiguration = require('../src/GeneralConfiguration');
  it('Should be a GeneralConfiguration', function() {
    return assert.equal(GeneralConfiguration.prototype.GeneralConfiguration, true);
  });
  describe('_constructor_', function() {
    return it('Should have a _constructor_', function() {
      return assert.typeOf(GeneralConfiguration.prototype._constructor_, 'function');
    });
  });
  describe('#constructor', function() {
    it('creating a GeneralConfiguration instance should not throw errors', function() {
      var generalConfiguration;

      return generalConfiguration = new GeneralConfiguration();
    });
    it('Should extends from a Logger', function() {
      return assert.equal(GeneralConfiguration.prototype.Logger, true);
    });
    it('Should extends from a ReadableEntity', function() {
      return assert.equal(GeneralConfiguration.prototype.ReadableEntity, true);
    });
    return it('Should extends from a TreeElement', function() {
      return assert.equal(GeneralConfiguration.prototype.TreeElement, true);
    });
  });
  describe('#readAllModules', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(GeneralConfiguration.prototype.readAllModules, 'function');
    });
    it('Should read all modules', function(cb) {
      var e, jelly;

      try {
        jelly = new Jelly();
        jelly.setRootDirectory("" + __dirname + "/testFiles/validGeneralConfig");
        return async.series([
          function(cb) {
            return jelly.readJellyConfigurationFile(function(err) {
              return cb(err, null);
            });
          }, function(cb) {
            return jelly.readAllGeneralConfigurationFiles(function(err) {
              return cb(err, null);
            });
          }
        ], function(err, res) {
          var e, generalConfig;

          try {
            assert.equal(err, null, 'files should be valid');
            assert.equal(jelly.getChildList().length, 1, 'there is only one generalConfiguration file in the validGeneralConfig directory');
            generalConfig = jelly.getChildList()[0];
            assert.equal(generalConfig.GeneralConfiguration, true, 'the child should be a GeneralConfiguration type');
            return generalConfig.readAllModules(function(err) {
              cb(err);
              return cb = function() {};
            });
          } catch (_error) {
            e = _error;
            cb(e);
            return cb = function() {};
          }
        });
      } catch (_error) {
        e = _error;
        return cb(e);
      }
    });
    return it('Should set default parameters if they do not exist', function(cb) {
      var generalConfig;

      generalConfig = new GeneralConfiguration();
      generalConfig.setId('test.json');
      return generalConfig.readUpdateAndExecute("" + __dirname + "/testFiles/empty.json", 'utf8', function(err) {
        if (err) {
          return cb(err);
        } else {
          return generalConfig.readAllModules(function(err) {
            var content, e;

            if (err) {
              cb(err);
              cb = function() {};
              return;
            }
            try {
              content = generalConfig.getLastExecutableContent();
              assert.equal(content.name, 'test', 'the default name should be the file without the json extension');
              assert.equal(content.moduleConfigurationFilename, 'assets.json');
              assert.typeOf(content.plugins, 'array');
              assert.equal(content.plugins.length, 0);
              assert.equal(toType(content.pluginParameters), 'object');
              assert.equal(JSON.stringify(content.pluginParameters), '{}');
              assert.typeOf(content.plugins, 'array');
              assert.equal(content.plugins.length, 0);
              return cb();
            } catch (_error) {
              e = _error;
              return cb(e);
            }
          });
        }
      });
    });
  });
  describe('#loadFromFilename', function() {
    it('Should be a callable function', function() {
      return assert.typeOf(GeneralConfiguration.prototype.loadFromFilename, 'function');
    });
    it('Should return an error if there is no jelly object as parent', function(cb) {
      var g;

      g = new GeneralConfiguration();
      return g.loadFromFilename("" + __dirname + "/testFiles/validGeneralConfig/conf/testConf1.json", function(err) {
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
    return it('Should return an error if there is no jelly object as parent', function(cb) {
      var g;

      g = new GeneralConfiguration();
      return g.loadFromFilename("" + __dirname + "/testFiles/validGeneralConfig/conf/testConf1.json", function(err) {
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
  return describe('#reload', function() {
    return it('Should be a callable function', function() {
      return assert.typeOf(GeneralConfiguration.prototype.reload, 'function');
    });
  });
});
