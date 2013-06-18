assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
Jelly = require('../src/Jelly');
GeneralConfiguration = require('../src/GeneralConfiguration');

describe('PluginInterface', ->
  PluginInterface = require('../src/PluginInterface')
  it('Should be a PluginInterface', ->
    assert.equal(PluginInterface.prototype.PluginInterface, true)
  )
#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(PluginInterface.prototype._constructor_, 'function');
    )
  )
#------------------------------------------------------------------------------------------
  describe('::STATUS', ->
    it('Should exist', ->
      assert.typeOf(PluginInterface::STATUS, 'object')
    )

    it('Should contain the status', ->
      assert.equal(PluginInterface::STATUS.NOT_LOADED, 0)
      assert.equal(PluginInterface::STATUS.LOADED, 1)
    )   
  )
#------------------------------------------------------------------------------------------
  describe('#constructor', ->
    it('creating an instance should not throw errors', ->
      pluginInterface = new PluginInterface()
    )
    it('Should extends from a Logger', ->
      assert.equal(PluginInterface.prototype.Logger, true)
    )
    it('Should extends from a ReadableEntity', ->
      assert.equal(PluginInterface.prototype.ReadableEntity, true)
    )
    it('Should extends from a TreeElement', ->
      assert.equal(PluginInterface.prototype.TreeElement, true)
    )
  )
#------------------------------------------------------------------------------------------
  describe('#unload', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginInterface.prototype.unload, 'function')
    )    
  )
)