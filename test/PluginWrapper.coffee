assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  

describe('PluginWrapper', ->
  PluginWrapper = require('../src/PluginWrapper')
  it('Should be a PluginWrapper', ->
    assert.equal(PluginWrapper.prototype.PluginWrapper, true)
  )
#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(PluginWrapper.prototype._constructor_, 'function');
    )
  )
#------------------------------------------------------------------------------------------
  describe('applyPlugin', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginWrapper.prototype.applyPlugin, 'function')
    )    
  )
)