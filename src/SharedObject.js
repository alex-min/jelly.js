// Generated by CoffeeScript 1.6.2
var File, Logger, ReadableEntity, SharedObject, Tools, TreeElement, async, fs, _SharedObject;

async = require('async');

fs = require('fs');

Tools = require('./Tools');

Logger = require('./Logger');

ReadableEntity = require('./ReadableEntity');

TreeElement = require('./TreeElement');

File = require('./File');

/**
 * SharedObject is a class to share objects between plugins.
 * 
 * @class SharedObject
 * @extends Logger
 * @extends ReadableEntity
 * @extends TreeElement
*/


SharedObject = Tools.implementing(Logger, ReadableEntity, TreeElement, _SharedObject = (function() {
  function _SharedObject() {}

  return _SharedObject;

})(), SharedObject = (function() {
  SharedObject.prototype._constructor_ = function() {
    return this._parentConstructor_();
  };

  function SharedObject() {
    this._constructor_();
  }

  return SharedObject;

})());

module.exports = SharedObject;
