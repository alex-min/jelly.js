// Generated by CoffeeScript 1.6.2
var File, Logger, Module, ReadableEntity, Tools, TreeElement, async, path, _Module;

async = require('async');

path = require('path');

Tools = require('./Tools');

Logger = require('./Logger');

ReadableEntity = require('./ReadableEntity');

TreeElement = require('./TreeElement');

File = require('./File');

/**
 * Module is a class dealing with framework Modules.
 * Each module is suppose to be under a different folder on the projet.
 * The main goal is to provide modules with reusable functions (login form, calendar, administration, stastistics...)
 * 
 * @class Module
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
*/


Module = Tools.implementing(Logger, ReadableEntity, TreeElement, _Module = (function() {
  function _Module() {}

  return _Module;

})(), Module = (function() {
  function Module() {
    this._constructor_();
  }

  Module.prototype._constructor_ = function() {
    return this._parentConstructor_();
  };

  Module.prototype._setDefaultContent = function(content) {
    var _ref, _ref1, _ref2, _ref3;

    if ((_ref = content.fileList) == null) {
      content.fileList = [];
    }
    if ((_ref1 = content.pathList) == null) {
      content.pathList = [];
    }
    if ((_ref2 = content.plugins) == null) {
      content.plugins = [];
    }
    if ((_ref3 = content.pluginParameters) == null) {
      content.pluginParameters = {};
    }
    content.modulePlugins = [];
    return content.modulePluginParameters = {};
  };

  /**
   * Load a module from its configuration file
   * This method must be called once when loading the module for the first time.
   * After this, only calls to the 'reload' method are allowed.
   *
   * @for Module
   * @method loadFromFilename
   * @param {String} filename The location of the file
   * @param {Function} callback : parameters (err : error occured)
  */


  Module.prototype.loadFromFilename = function(filename, cb) {
    var e, self;

    self = this;
    cb = cb || function() {};
    try {
      return this.readUpdateAndExecute(filename, 'utf8', function(err) {
        var e;

        try {
          if (err != null) {
            cb(err);
            return cb = function() {};
          } else {
            self.reload.call(self, cb);
            return cb = function() {};
          }
        } catch (_error) {
          e = _error;
          cb(e);
          return cb = function() {};
        }
      });
    } catch (_error) {
      e = _error;
      cb(e);
      return cb = function() {};
    }
  };

  /**
   * Do the necessary calls to reload the module (it must be loaded before calling this)
   * Currently equivalent to the readAllFiles method 
   *
   * @for Module
   * @method reload
   * @param {Function} callback : parameters (err : error occured)
  */


  Module.prototype.reload = function(cb) {
    return this.readAllFiles(cb);
  };

  /**
   * Read all the files specified under the 'fileList' array section of each module configuration file
   *
   * @for Module
   * @method readAllFiles
   * @param {Function} callback : parameters (err : error occured)
  */


  Module.prototype.readAllFiles = function(cb) {
    var content, e, self;

    self = this;
    cb = cb || function() {};
    this.getLogger().info('Reading all files');
    try {
      content = this.getLastExecutableContent();
      if (content === null) {
        cb(new Error('There is no executable content pushed on the Module Class'));
        cb = function() {};
        return;
      }
      if (this.getId() === null) {
        cb(new Error("There is no Id bound to the module"));
        cb = function() {};
        return;
      }
      this._setDefaultContent(content);
      return async.map(content.fileList, function(file, cb) {
        var e, fileId, generalConfig;

        fileId = "" + (self.getId()) + "-" + file.name;
        try {
          file = self.getChildById(fileId);
          if (file === null) {
            file = new File();
            file.setId(fileId);
            file.setParent(self);
            generalConfig = self.getParent();
            if (typeof generalConfig === 'undefined' || generalConfig === null) {
              cb(new Error('There is no GeneralConfiguration parent on the Module object (you should call Module::setParent if you are using this class manualy)'));
              cb = function() {};
              return;
            }
          }
          return self.addChild(file, function(err) {
            var e, extension, fileLocation, jelly, pathExtension;

            try {
              extension = path.extname(fileId);
              if (!content.pathList[extension]) {
                content.pathList[extension] = "/" + (extension.replace('.', ''));
              }
              pathExtension = content.pathList[extension];
              generalConfig = self.getParent();
              jelly = generalConfig.getParent();
              if (jelly === null || typeof jelly === 'undefined') {
                cb(new Error('There is no jelly parent on the file (file.getParent().getParent() == null), you should call GeneralConfiguration::setParent() if you are using this class manualy'));
                cb = function() {};
                return;
              }
              if (self.getId() === null) {
                cb(new Error("The module needs to have an Id to load a file, please call Module::setId() if you are using this class manualy"));
                return;
              }
              fileLocation = "" + (jelly.getApplicationDirectory()) + "/" + (self.getId()) + "/" + pathExtension + "/" + fileId;
              return file.loadFromFilename(fileLocation, function(err) {
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
          cb(e);
          return cb = function() {};
        }
      }, function(err) {
        cb(err);
        return cb = function() {};
      });
    } catch (_error) {
      e = _error;
      cb(e);
      cb = function() {};
    }
  };

  return Module;

})());

module.exports = Module;
