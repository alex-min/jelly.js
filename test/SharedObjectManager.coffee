assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()

File = require('../src/File')
Module = require('../src/Module')
PluginHandler = require('../src/PluginHandler')
Tools = require('../src/Tools')
ReadableEntity = require('../src/ReadableEntity')
TreeElement = require('../src/TreeElement')
GeneralConfiguration = require('../src/GeneralConfiguration')
Jelly = require('../src/Jelly')
SharedObjectManager = require('../src/SharedObjectManager')

describe('SharedObjectManager', ->
#------------------------------------------------------------------------------------------
  ## constructor
  describe('#constructor', ->
    it('creating an instance should not throw errors', ->
      sharedObjectManager = new SharedObjectManager()
    )
  )
#------------------------------------------------------------------------------------------
  describe('#registerObject', ->
    it('Should be a callable function', ->
      assert.typeOf(SharedObjectManager.prototype.registerObject, 'function')
    )
    it('Should register content', ->
      sharedObject = new SharedObjectManager()
      sharedObject.registerObject('A','B', 'TEST')
      obj = sharedObject.getObject('A', 'B')
      assert.equal(toType(obj), 'object')
      assert.equal(obj.SharedObject, true)
      assert.equal(obj.getCurrentContent(), 'TEST')
      sharedObject.registerObject('A','B', 'TEST2')
      assert.equal(obj.getCurrentContent(), 'TEST2')
    )    
  )
  describe('#getObject', ->
    it('Should be a callable function', ->
      assert.typeOf(SharedObjectManager.prototype.getObject, 'function')
    )
    it('Should return null when there is no object bound', ->
      assert.equal(new SharedObjectManager().getObject(), null)
    )    
    # there is enouth tests on the #registerObject function, no need to add more tests
  )
)