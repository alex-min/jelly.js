// Generated by CoffeeScript 1.6.2
var File, Logger, PluginHandler, PluginWrapper, ReadableEntity, Tools, TreeElement, async, fs;

async = require('async');

fs = require('fs');

Tools = require('./Tools');

Logger = require('./Logger');

ReadableEntity = require('./ReadableEntity');

TreeElement = require('./TreeElement');

File = require('./File');

PluginHandler = require('./PluginHandler');

/**
 * PluginWrapper is a class providing plugin capabilities to another class.
 * Jelly, GeneralConfiguration, Module and File are inheriting from it. 
 * 
 * @class PluginWrapper
*/


PluginWrapper = (function() {
  PluginWrapper.prototype.PluginWrapper = true;

  PluginWrapper.prototype._constructor_ = function() {};

  function PluginWrapper() {
    this._constructor_();
  }

  PluginWrapper.prototype._applyPluginFile = function(pluginHandler, cb) {
    var config, module;

    module = this.getParent();
    if (module === null || typeof module === 'undefined') {
      cb(new Error("The specified File '" + (this.getId()) + "' does not have a parent module"));
      cb = function() {};
      return;
    }
    config = module.getLastExecutableContent();
    if (config === null) {
      cb(new Error("There is no config file read on the parent module of the File '" + (this.getId()) + "'"));
      cb = function() {};
      return;
    }
    return pluginHandler.getPluginInterface().oncall(this, {
      plugins: config.filePlugins,
      pluginParameters: config.filePluginParameters
    }, cb);
  };

  PluginWrapper.prototype._applyPluginOtherClass = function(pluginHandler, cb) {
    var config, self;

    self = this;
    config = self.getLastExecutableContent();
    if (config === null) {
      cb(new Error("There is no config file loaded for the Id '" + (self.getId()) + "' on a " + self.constructor.name + " object"));
      cb = function() {};
      return;
    }
    return pluginHandler.getPluginInterface().oncall(self, {
      plugins: config.plugins,
      pluginParameters: config.pluginParameters
    }, cb);
  };

  /**
   * Apply a plugin to the current class (this). Only for class which extends from a PluginWrapper.
   *
   * @for PluginWrapper
   * @method applyPlugin
   * @aync
   * @param {PluginHandler} The plugin to apply to the class
   * @param {String} filename The location of the file
   * @param {Function} callback : parameters (err : error occured)
  */


  PluginWrapper.prototype.applyPlugin = function(pluginHandler, cb) {
    var self;

    cb = cb || function() {};
    self = this;
    if (typeof pluginHandler === 'undefined' || pluginHandler === null || pluginHandler.PluginHandler !== true) {
      cb(new Error("Unable to apply plugin : Invalid pluginHandler passed as a parameter"));
      cb = function() {};
      return;
    }
    if (self.ReadableEntity !== true) {
      cb(new Error("Unable to apply plugin : The class must inherit from ReadableEntity to use this method"));
      return;
    }
    if (self.File === true) {
      return this._applyPluginFile(pluginHandler, cb);
    } else {
      return this._applyPluginOtherClass(pluginHandler, cb);
    }
  };

  return PluginWrapper;

})();

module.exports = PluginWrapper;
