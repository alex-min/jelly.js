// Generated by CoffeeScript 1.6.2
var File, Logger, PluginInterface, ReadableEntity, Tools, TreeElement, async, fs, _PluginInterface;

async = require('async');

fs = require('fs');

Tools = require('./Tools');

Logger = require('./Logger');

ReadableEntity = require('./ReadableEntity');

TreeElement = require('./TreeElement');

File = require('./File');

/**
 * PluginInterface is the child class of PluginHandler.
 * Each PluginHandler instance is suppose to contain a PluginInterface class.
 * This class is dealing directly with the plugin code.
 * 
 * @class PluginInterface
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
*/


PluginInterface = Tools.implementing(Logger, ReadableEntity, TreeElement, _PluginInterface = (function() {
  function _PluginInterface() {}

  return _PluginInterface;

})(), PluginInterface = (function() {
  function PluginInterface() {
    this._constructor_();
  }

  PluginInterface.prototype._constructor_ = function() {
    this._parentConstructor_();
    return this._status = PluginInterface.prototype.STATUS.NOT_LOADED;
  };

  /**
   *  @property STATUS
   *  @type Object
   *  @static
   *  @final
   *  @readOnly
  */


  PluginInterface.prototype.STATUS = {
    NOT_LOADED: 0,
    LOADED: 1
  };

  PluginInterface.prototype.unload = function(cb) {
    cb = cb || function() {};
    return cb();
  };

  PluginInterface.prototype.load = function(cb) {
    cb = cb || function() {};
    return cb();
  };

  PluginInterface.prototype.readFile = function(filename, cb) {
    var self;

    self = this;
    cb = cb || function() {};
    return async.series([
      function(cb) {
        return self.unload(cb);
      }, function(cb) {
        return cb();
      }
    ], function(err) {
      return cb(err);
    });
  };

  return PluginInterface;

})());

module.exports = PluginInterface;
