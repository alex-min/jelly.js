assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
Jelly = require('../src/Jelly');
GeneralConfiguration = require('../src/GeneralConfiguration');

describe('PluginDirectory', ->
  PluginDirectory = require('../src/PluginDirectory')
  it('Should be a PluginDirectory', ->
    assert.equal(PluginDirectory.prototype.PluginDirectory, true)
  )
#------------------------------------------------------------------------------------------
  describe('#', ->
    
  )
)