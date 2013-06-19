assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
PluginDirectory = require('../src/PluginDirectory');
PluginHandler = require('../src/PluginHandler');



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
  describe('#getPluginHandlerById', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginList.prototype.getPluginHandlerById, 'function')
    )
    it('Should return null when null is passed as an id',  ->
      dir = new PluginDirectory()
      handler = new PluginHandler()
      handler.setParent(dir)
      dir.addChild(handler)
      p = new PluginList()
      handler.setParent(p)
      p.addChild(handler)
      plug = new PluginList();
      plug.addChild(dir)
      dir.setParent(p)
      res = plug.getPluginHandlerById(null);
      assert.equal(res, null)
    )
    it('Should return the plugin handler by its id', ->
      dir = new PluginDirectory()
      handler = new PluginHandler()
      handler.setParent(dir)
      handler.setId('HandlerID');
      dir.addChild(handler)
      p = new PluginList()
      handler.setParent(p)
      p.addChild(handler)
      plug = new PluginList();
      plug.addChild(dir)
      dir.setParent(p)
      res = plug.getPluginHandlerById('HandlerID');
      assert.typeOf(res, 'object')
      assert.equal(res.PluginHandler, true)
    )

    it('Should return null if nothing is found', ->
      dir = new PluginDirectory()
      handler = new PluginHandler()
      handler.setParent(dir)
      handler.setId('OtherID');
      dir.addChild(handler)
      p = new PluginList()
      handler.setParent(p)
      p.addChild(handler)
      plug = new PluginList();
      plug.addChild(dir)
      dir.setParent(p)
      res = plug.getPluginHandlerById('HandlerID');
      assert.equal(res, null)
    )
  )
#------------------------------------------------------------------------------------------
)
