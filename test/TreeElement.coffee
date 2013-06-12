assert = require('chai').assert
async = require('async')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  

describe('TreeElement', ->
  TreeElement = require('../src/TreeElement');
  it('Should be a TreeElement', ->
    assert.equal(TreeElement.prototype.TreeElement, true)
  )

#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(TreeElement.prototype._constructor_, 'function');
    )
  )

#------------------------------------------------------------------------------------------
  describe('#getChildList', ->
    it('Should be callable function', ->
      assert.typeOf(TreeElement.prototype.getChildList, 'function')
    )
    it('Should return an empty array when nothing is set', ->
      treeElement = new TreeElement()
      assert.equal(toType(treeElement.getChildList()), 'array');
      assert.equal(treeElement.getChildList().length, 0)
    )
    it('Should return an error if the child is not a TreeElement', (cb) ->
      treeElement = new TreeElement();
      treeElement.addChild('pelos', (err, child) ->
        try
          assert.equal(child, null)
          assert.equal(toType(err), 'error')
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should push a child element', (cb) ->
      treeElement = new TreeElement()
      child = new TreeElement()
      child.__TEST__ = 1;
      treeElement.addChild(child, (err,child) ->
        try
          check = ((child) ->
            assert.equal(err, null)
            assert.equal(Object.getPrototypeOf(child).TreeElement, true)
            assert.equal(child.__TEST__, 1);
          )
          check(child)
          check(treeElement.getChildList()[0])
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )

    it('Should push a child element only once', (cb) ->
      treeElement = new TreeElement()
      child = new TreeElement()
      child.setId('child')
      treeElement.addChild(child , (err) ->
        try
          assert.equal(err, null)
          treeElement.addChild(child, (err) ->
            try
              assert.equal(err, null)
              assert.equal(treeElement.getChildList().length, 1)
              cb()
            catch e
              cb(e)
          )
        catch e
          cb(e)
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getParent', ->
    it('Should be callable function', ->
      assert.typeOf(TreeElement.prototype.getParent, 'function')
    )
    it('Should return null when nothing is set', ->
      assert.equal(new TreeElement().getParent(), null)
    )
    it('Should return the parent when a parent is set', ->
      t1 = new TreeElement()
      t1.__PARENT__ = 1
      t2 = new TreeElement()
      t2.setParent(t1, (err) ->
        assert.equal(err, null)
        assert.equal(t2.getParent().__PARENT__, 1)
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#setId', ->
    it('Should be callable function', ->
      assert.typeOf(TreeElement.prototype.setId, 'function')
    )
    it('Should set the id of the TreeElement', ->
      elm = new TreeElement()
      elm.setId('A')
      assert.equal(elm.getId(), 'A')
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getId', ->
    it('Should be callable function', ->
      assert.typeOf(TreeElement.prototype.getId, 'function')
    )
    # if it worked for #setKey, it will work here, no need for more tests   
  )

#------------------------------------------------------------------------------------------
  describe('#getChildById', ->
    it('Should be callable function', ->
      assert.typeOf(TreeElement.prototype.getChildById, 'function')
    )
    it('Should be return null if the key is null', ->
      a = new TreeElement()
      b = new TreeElement()
      a.addChild(b)
      assert.equal(a.getChildById(null), null);
    )
    it('Should return a child if a key match', ->
      a = new TreeElement()
      b = new TreeElement()
      a.addChild(b)
      b.setId('b')
      b.__TEST__ = 1
      assert.typeOf(a.getChildById('b'), 'Object')
      assert.equal(a.getChildById('b').__TEST__, 1, 'b was not returned as expected')
    )
  )
)