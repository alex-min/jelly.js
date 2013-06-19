assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  


describe('PluginList', ->
  PluginList = require('../src/PluginList');

#------------------------------------------------------------------------------------------
  describe('#constructor', ->
    it('creating an instance should not throw errors', ->
      new PluginList()
    )
    it('Should extends from a Logger', ->
      assert.equal(PluginList.prototype.Logger, true)
    )
    it('Should extends from a ReadableEntity', ->
      assert.equal(PluginList.prototype.ReadableEntity, true)
    )
    it('Should extends from a TreeElement', ->
      assert.equal(PluginList.prototype.TreeElement, true)
    )
  )

#------------------------------------------------------------------------------------------
