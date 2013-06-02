// Generated by CoffeeScript 1.6.2
var GeneralConfiguration, Jelly, Logger, ReadableEntity, Tools, async, fs, _Jelly;

fs = require('fs');

async = require('async');

GeneralConfiguration = require('./GeneralConfiguration');

Logger = require('./Logger');

Tools = require('./Tools');

ReadableEntity = require('./ReadableEntity');

/**
 * Jelly is the main class of the framework
 * 
 * @class Jelly
*/


Jelly = Tools.implementing(Logger, ReadableEntity, _Jelly = (function() {
  function _Jelly() {}

  return _Jelly;

})(), Jelly = (function() {
  Jelly.prototype._constructor_ = function() {
    this._parentConstructor_();
    this.getLogger().info('Jelly: Creating a new instance.');
    return this._rootDirectory = __dirname;
  };

  function Jelly() {
    this._constructor_();
  }

  /**
   * Returns the current root directory
   * Should return __dirname if nothing is set.
   *
   * @for Jelly
   * @method getRootDirectory
   * @return {String} Root directory
  */


  Jelly.prototype.getRootDirectory = function() {
    return this._rootDirectory;
  };

  /**
   * Sets the current root directory
   *
   * @for Jelly
   * @method setRootDirectory
   * @return {String} Root directory
  */


  Jelly.prototype.setRootDirectory = function(dir) {
    this.getLogger().info("Jelly: the root directory is now set to " + dir);
    return this._rootDirectory = dir;
  };

  /**
   * Checks if the rootDirectory is valid (and all their subfolders)
   *
   * @for Jelly
   * @method checkRootDirectory
   * @param {cb} Callback to fire, parameters : (err), if there is no error, err is null
   * @return {String} Root directory
  */


  Jelly.prototype.checkRootDirectory = function(cb) {
    var root;

    cb = cb || function() {};
    root = this._rootDirectory;
    return async.each([root, "" + root + "/conf", "" + root + "/app"], function(dir, cb) {
      return fs.stat(dir, function(err, st) {
        var e;

        try {
          if (err) {
            cb(new Error(err), null);
            cb = function() {};
            return;
          }
          if (!(st.isDirectory())) {
            cb(new Error("" + dir + " is not a valid directory"), null);
            cb = function() {};
            return;
          }
          return cb(null);
        } catch (_error) {
          e = _error;
          cb(e, null);
          return cb = function() {};
        }
      });
    }, function(err) {
      cb(err);
      return cb = function() {};
    });
  };

  /**
   * read the main configuration file (/conf/JellyConf.json), the is no interpretation yet
   *
   * @for Jelly
   * @method setRootDirectory
   * @return {String} Root directory
  */


  Jelly.prototype.readJellyConfigurationFile = function(cb) {
    var e, fileLocation, rootdir, self;

    self = this;
    cb = cb || function() {};
    try {
      rootdir = this.getRootDirectory();
      fileLocation = "" + rootdir + "/conf/JellyConf.json";
      return async.series([
        function(cb) {
          return self.checkRootDirectory(function(err) {
            return cb(err, null);
          });
        }, function(cb) {
          return self.updateContentFromFile(fileLocation, 'utf8', function(err, res) {
            return cb(err, res);
          });
        }, function(cb) {
          return self.updateAndExecuteCurrentContent(function(err) {
            return cb(err);
          });
        }
      ], function(err, res) {
        res = res.length >= 2 ? res[1] : null;
        return cb(err, res);
      });
    } catch (_error) {
      e = _error;
      cb(e, null);
      return cb = function() {};
    }
  };

  Jelly.prototype.readAllGeneralConfigurationFiles = function(cb) {
    var content, _ref;

    content = this.getLastExecutableContent();
    if (content === null) {
      cb(new Error('There is no executable content pushed on the Jelly Class'));
      cb = function() {};
      return;
    }
    if ((_ref = content.listOfConfigurationFiles) == null) {
      content.listOfConfigurationFiles = [];
    }
    return async.map(content.listOfConfigurationFiles, function(config, cb) {});
  };

  return Jelly;

})());

Tools.include(Jelly, ReadableEntity);

module.exports = Jelly;
