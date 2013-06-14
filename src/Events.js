// Generated by CoffeeScript 1.6.2
var Events, events,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

events = require('events');

/**
 * Events is a class to deal with node's Events api
 * The main goal of this class is to provide listeners and emitters with events
 * 
 * @class Events
*/


Events = (function(_super) {
  __extends(Events, _super);

  function Events() {
    this._constructor_();
  }

  Events.prototype._constructor_ = function() {};

  return Events;

})(events.EventEmitter);

module.exports = Events;
