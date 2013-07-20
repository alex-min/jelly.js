// Generated by CoffeeScript 1.6.2
var assert, async, toType;

assert = require('chai').assert;

async = require('async');

toType = function(obj) {
  return {}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
};

describe('TreeElement', function() {
  var TreeElement;

  TreeElement = require('../src/TreeElement');
  it('Should be a TreeElement', function() {
    return assert.equal(TreeElement.prototype.TreeElement, true);
  });
  describe('_constructor_', function() {
    return it('Should have a _constructor_', function() {
      return assert.typeOf(TreeElement.prototype._constructor_, 'function');
    });
  });
  describe('#getChildByIdRec', function() {
    it('Should be callable function', function() {
      return assert.typeOf(TreeElement.prototype.getChildByIdRec, 'function');
    });
    it('Should null when nothing set', function() {
      return assert.equal(new TreeElement().getChildByIdRec(), null);
    });
    it('Should return a child id or itself if the Id match', function() {
      var t1, t2, t3;

      t1 = new TreeElement();
      t1.setId('a');
      t2 = new TreeElement();
      t2.setId('b');
      t3 = new TreeElement();
      t3.setId('c');
      t3.addChild(t2);
      t3.addChild(t1);
      assert.equal(toType(t3.getChildByIdRec('a')), 'object');
      assert.equal(toType(t3.getChildByIdRec('b')), 'object');
      return assert.equal(toType(t3.getChildByIdRec('c')), 'object');
    });
    return it('Should return a child of child', function() {
      var t1, t2, t3, t4;

      t1 = new TreeElement();
      t1.setId('a');
      t2 = new TreeElement();
      t2.setId('b');
      t3 = new TreeElement();
      t3.setId('c');
      t4 = new TreeElement();
      t4.setId('d');
      t3.addChild(t2);
      t2.addChild(t1);
      t2.addChild(t4);
      assert.equal(toType(t3.getChildByIdRec('d')), 'object');
      assert.equal(toType(t3.getChildByIdRec('b')), 'object');
      assert.equal(toType(t3.getChildByIdRec('c')), 'object');
      return assert.equal(toType(t3.getChildById('d')), 'null');
    });
  });
  describe('#getChildList', function() {
    it('Should be callable function', function() {
      return assert.typeOf(TreeElement.prototype.getChildList, 'function');
    });
    it('Should return an empty array when nothing is set', function() {
      var treeElement;

      treeElement = new TreeElement();
      assert.equal(toType(treeElement.getChildList()), 'array');
      return assert.equal(treeElement.getChildList().length, 0);
    });
    it('Should return an error if the child is not a TreeElement', function(cb) {
      var treeElement;

      treeElement = new TreeElement();
      return treeElement.addChild('pelos', function(err, child) {
        var e;

        try {
          assert.equal(child, null);
          assert.equal(toType(err), 'error');
          cb();
          return cb = function() {};
        } catch (_error) {
          e = _error;
          cb(e);
          return cb = function() {};
        }
      });
    });
    it('Should push a child element', function(cb) {
      var child, treeElement;

      treeElement = new TreeElement();
      child = new TreeElement();
      child.__TEST__ = 1;
      return treeElement.addChild(child, function(err, child) {
        var check, e;

        try {
          check = (function(child) {
            assert.equal(err, null);
            assert.equal(Object.getPrototypeOf(child).TreeElement, true);
            return assert.equal(child.__TEST__, 1);
          });
          check(child);
          check(treeElement.getChildList()[0]);
          cb();
          return cb = function() {};
        } catch (_error) {
          e = _error;
          cb(e);
          return cb = function() {};
        }
      });
    });
    return it('Should push a child element only once', function(cb) {
      var child, treeElement;

      treeElement = new TreeElement();
      child = new TreeElement();
      child.setId('child');
      return treeElement.addChild(child, function(err) {
        var e;

        try {
          assert.equal(err, null);
          return treeElement.addChild(child, function(err) {
            var e;

            try {
              assert.equal(err, null);
              assert.equal(treeElement.getChildList().length, 1);
              return cb();
            } catch (_error) {
              e = _error;
              return cb(e);
            }
          });
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      });
    });
  });
  describe('#getParent', function() {
    it('Should be callable function', function() {
      return assert.typeOf(TreeElement.prototype.getParent, 'function');
    });
    it('Should return null when nothing is set', function() {
      return assert.equal(new TreeElement().getParent(), null);
    });
    return it('Should return the parent when a parent is set', function() {
      var t1, t2;

      t1 = new TreeElement();
      t1.__PARENT__ = 1;
      t2 = new TreeElement();
      return t2.setParent(t1, function(err) {
        assert.equal(err, null);
        return assert.equal(t2.getParent().__PARENT__, 1);
      });
    });
  });
  describe('#setId', function() {
    it('Should be callable function', function() {
      return assert.typeOf(TreeElement.prototype.setId, 'function');
    });
    return it('Should set the id of the TreeElement', function() {
      var elm;

      elm = new TreeElement();
      elm.setId('A');
      return assert.equal(elm.getId(), 'A');
    });
  });
  describe('#getId', function() {
    return it('Should be callable function', function() {
      return assert.typeOf(TreeElement.prototype.getId, 'function');
    });
  });
  return describe('#getChildById', function() {
    it('Should be callable function', function() {
      return assert.typeOf(TreeElement.prototype.getChildById, 'function');
    });
    it('Should be return null if the key is null', function() {
      var a, b;

      a = new TreeElement();
      b = new TreeElement();
      a.addChild(b);
      return assert.equal(a.getChildById(null), null);
    });
    return it('Should return a child if a key match', function() {
      var a, b;

      a = new TreeElement();
      b = new TreeElement();
      a.addChild(b);
      b.setId('b');
      b.__TEST__ = 1;
      assert.typeOf(a.getChildById('b'), 'Object');
      return assert.equal(a.getChildById('b').__TEST__, 1, 'b was not returned as expected');
    });
  });
});
