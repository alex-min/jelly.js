// Generated by CoffeeScript 1.6.2
var extend,
  __slice = [].slice;

exports.toType = function(obj) {
  return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
};

exports.implementing = function() {
  var classReference, func, key, mixin, mixins, value, _base, _base1, _i, _j, _k, _len, _len1, _ref, _ref1, _ref2, _ref3, _ref4;

  mixins = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), classReference = arguments[_i++];
  if ((_ref = classReference.__super__) == null) {
    classReference.__super__ = [];
  }
  classReference.prototype[classReference.prototype.constructor.name] = true;
  for (_j = 0, _len = mixins.length; _j < _len; _j++) {
    mixin = mixins[_j];
    classReference.__super__.push(mixin);
    _ref1 = mixin.prototype;
    for (key in _ref1) {
      value = _ref1[key];
      if (key === '_ctorList') {
        if ((_ref2 = (_base = classReference.prototype)._ctorList) == null) {
          _base._ctorList = [];
        }
        _ref3 = mixin.prototype._ctorList;
        for (_k = 0, _len1 = _ref3.length; _k < _len1; _k++) {
          func = _ref3[_k];
          classReference.prototype._ctorList.push(func);
        }
      } else if (key !== '_constructor_') {
        classReference.prototype[key] = value;
      } else {
        if ((_ref4 = (_base1 = classReference.prototype)._ctorList) == null) {
          _base1._ctorList = [];
        }
        classReference.prototype._ctorList.push(mixin.prototype._constructor_);
      }
    }
  }
  classReference.prototype._parentConstructor_ = function() {
    var fct, _base2, _l, _len2, _ref5, _ref6, _results;

    if ((_ref5 = (_base2 = classReference.prototype)._ctorList) == null) {
      _base2._ctorList = [];
    }
    _ref6 = classReference.prototype._ctorList;
    _results = [];
    for (_l = 0, _len2 = _ref6.length; _l < _len2; _l++) {
      fct = _ref6[_l];
      _results.push(fct.call(this));
    }
    return _results;
  };
  classReference.prototype._selfClassName = classReference.prototype.constructor.name;
  return classReference;
};

extend = function(obj, mixin) {
  var method, name, _results;

  _results = [];
  for (name in mixin) {
    method = mixin[name];
    _results.push(obj[name] = method);
  }
  return _results;
};
