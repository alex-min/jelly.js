assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
Jelly = require('../src/Jelly');
GeneralConfiguration = require('../src/GeneralConfiguration');

describe('PluginHandler', ->
  PluginHandler = require('../src/PluginHandler')
  it('Should be a PluginHandler', ->
    assert.equal(PluginHandler.prototype.PluginHandler, true)
  )
#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(PluginHandler.prototype._constructor_, 'function');
    )
  )

#------------------------------------------------------------------------------------------
  describe('#readConfigFile', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginHandler.prototype.readConfigFile, 'function')
    )

    it('Should raise an error when there is no directory bound to the PluginHandler', (cb) ->
      new PluginHandler().readConfigFile((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )    
    )   
  )

  
)