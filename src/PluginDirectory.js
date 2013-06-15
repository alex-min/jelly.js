// Generated by CoffeeScript 1.6.2
var File, Logger, PluginDirectory, PluginHandler, ReadableEntity, Tools, TreeElement, async, fs, _PluginDirectory;

async = require('async');

fs = require('fs');

Tools = require('./Tools');

Logger = require('./Logger');

ReadableEntity = require('./ReadableEntity');

TreeElement = require('./TreeElement');

File = require('./File');

PluginHandler = require('./PluginHandler');

/**
 * PluginDirectory is the parent class of PluginHandler.
 * Each Jelly instance is suppose to contain a PluginDirectory class with multiple PluginHandler in it.
 * This class is dealing only with general methods related to all plugins.
 * To use a plugin directly, look at the PluginHandler class.
 * 
 * @class PluginDirectory
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
*/


PluginDirectory = Tools.implementing(Logger, ReadableEntity, TreeElement, _PluginDirectory = (function() {
  function _PluginDirectory() {}

  return _PluginDirectory;

})(), PluginDirectory = (function() {
  function PluginDirectory() {
    this._constructor_();
  }

  PluginDirectory.prototype._constructor_ = function() {
    return this._parentConstructor_();
  };

  /**
   * Get the logger class for external usage
   *
   * @for PluginDirectory
   * @method readAllPlugins
   * @async
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
  */


  PluginDirectory.prototype.readAllPlugins = function(cb) {
    var e, jelly, self;

    self = this;
    cb = cb || function() {};
    try {
      jelly = this.getParent();
      if (jelly === null || typeof jelly === 'undefined') {
        cb(new Error("The PluginDirectory class must be bound to a Jelly configuration file. Please call PluginDirectory::setParent() if you are using this class manualy."));
        cb = function() {};
        return;
      }
      return async.series([
        function(cb) {
          return self.readPluginDirectory("" + __dirname + "/plugins", cb);
        }, function(cb) {
          return self.readPluginDirectory(jelly.getPluginDirectory(), cb);
        }
      ], function(err) {
        cb(err);
        return cb = function() {};
      });
    } catch (_error) {
      e = _error;
      return cb(e);
    }
  };

  /**
   * Read a entire folder full of plugins.
   * This method will read recursively the folder and load all plugins.
   * If a plugin is invalid, no error will be returned and the plugin will be ignored.
   * This method will call readPluginFromPath recursively.
   *
   * @for PluginDirectory
   * @method readPluginDirectory
   * @async
   * @param dir The directory to read
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
  */


  PluginDirectory.prototype.readPluginDirectory = function(dir, cb) {
    var e, self;

    self = this;
    cb = cb || function() {};
    try {
      if (dir === null || typeof dir === 'undefined') {
        cb(new Error('Invalid parameter: directory == null'));
        cb = function() {};
        return;
      }
      return fs.readdir(dir, function(err, files) {
        if (err != null) {
          cb(err);
          cb = function() {};
          return;
        }
        return async.map(files, function(file, cb) {
          return self.readPluginFromPath("" + dir + "/" + file, file, function(err) {
            if (err != null) {
              self.getLogger().info("Unable to load plugin " + file + " " + err);
            }
            return cb();
          });
        }, function(err) {
          return cb(err);
        });
      });
    } catch (_error) {
      e = _error;
      return cb(e);
    }
  };

  /**
   * Read a plugin from its directory.
   * This method will create multiple instances of the PluginHandler class and will attach them as child of the PluginDirectory. 
   * This method should return errors when the plugin is invalid.
   *
   * @for PluginDirectory
   * @method readPluginFromPath
   * @async
   * @param dir The directory to read
   * @param pluginName The pluginName which will be set as an id (usually its the folder name)
   * @param {Function}[callback] callback function
   * @param {String} callback.err Error found during execution
   * @param {PluginHandler} callback.pluginHandler The plugin instance created (or null if there is an error)
  */


  PluginDirectory.prototype.readPluginFromPath = function(dir, pluginName, cb) {
    var e, self;

    cb = cb || function() {};
    self = this;
    try {
      if (dir === null || typeof dir === 'undefined') {
        cb(new Error("An invalid 'null' value was given as directory for pluginName " + pluginName), null);
        cb = function() {};
        return;
      }
      if (pluginName === null || typeof pluginName === 'undefined') {
        cb(new Error("An invalid 'null' value was given as pluginName for directory " + dir), null);
        cb = function() {};
        return;
      }
      this.getLogger().info("Reading plugin '" + pluginName + "' <" + dir + ">");
      return fs.stat("" + dir, function(err, stats) {
        var pluginHandler;

        if (err != null) {
          cb(new Error("" + dir + " is an invalid directory : " + err), null);
          cb = function() {};
          return;
        }
        if (!(stats.isDirectory())) {
          cb(new Error("" + dir + " is not a directory on plugin " + pluginName), null);
          cb = function() {};
          return;
        }
        pluginHandler = self.getChildById(pluginName);
        if (pluginHandler === null) {
          pluginHandler = new PluginHandler();
          pluginHandler.setId(pluginName);
          pluginHandler.updateContent({
            directory: dir
          });
          pluginHandler.setParent(self);
        }
        return self.addChild(pluginHandler, function(err) {
          return pluginHandler.reload(function(err) {
            cb(err, pluginHandler);
            return cb = function() {};
          });
        });
      });
    } catch (_error) {
      e = _error;
      return cb(e);
    }
  };

  return PluginDirectory;

})());

module.exports = PluginDirectory;
