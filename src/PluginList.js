// Generated by CoffeeScript 1.6.2
var File, Logger, PluginList, ReadableEntity, Tools, TreeElement, async, fs, _PluginList;

async = require('async');

fs = require('fs');

Tools = require('./Tools');

Logger = require('./Logger');

ReadableEntity = require('./ReadableEntity');

TreeElement = require('./TreeElement');

File = require('./File');

/**
 * PluginList is a class containing multiple PluginDirectory classes.
 * This class is the root class for all plugins.
 * 
 * @class PluginList
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
*/


PluginList = Tools.implementing(Logger, ReadableEntity, TreeElement, _PluginList = (function() {
  function _PluginList() {}

  return _PluginList;

})(), PluginList = (function() {
  function PluginList() {
    this._constructor_();
  }

  PluginList.prototype._constructor_ = function() {
    return this._parentConstructor_();
  };

  /**
   * Searching for a pluginHandler recursively for a specifid id.
   * {PluginList} -> {PluginDirectory} -> {PluginHandler} -> {PluginInterface}.
   *
   * @for PluginList
   * @method getPluginHandlerById
   * @param {String} id The id to search
  */


  PluginList.prototype.getPluginHandlerById = function(id) {
    var directory, handler, _i, _j, _len, _len1, _ref, _ref1;

    if (id === null || typeof id === 'undefined') {
      return null;
    }
    _ref = this.getChildList();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      directory = _ref[_i];
      _ref1 = directory.getChildList();
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        handler = _ref1[_j];
        if (id === handler.getId()) {
          return handler;
        }
      }
    }
    return null;
  };

  return PluginList;

})());

module.exports = PluginList;