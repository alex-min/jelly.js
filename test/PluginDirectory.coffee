assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  

Jelly = require('../src/Jelly')
Logger = require('../src/Logger')
TreeElement = require('../src/TreeElement')
GeneralConfiguration = require('../src/GeneralConfiguration')
Module = require('../src/Module')
File = require('../src/File')
PluginHandler = require('../src/PluginHandler')


describe('PluginDirectory', ->
  PluginDirectory = require('../src/PluginDirectory')
  it('Should be a PluginDirectory', ->
    assert.equal(PluginDirectory.prototype.PluginDirectory, true)
  )
#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(PluginDirectory.prototype._constructor_, 'function');
    )
  )

#------------------------------------------------------------------------------------------
  describe('#constructor', ->
    it('creating an instance should not throw errors', ->
      m = new PluginDirectory()
    )
    it('Should extends from a Logger', ->
      assert.equal(PluginDirectory.prototype.Logger, true)
    )
    it('Should extends from a ReadableEntity', ->
      assert.equal(PluginDirectory.prototype.ReadableEntity, true)
    )
    it('Should extends from a TreeElement', ->
      assert.equal(PluginDirectory.prototype.TreeElement, true)
    )
  )
#------------------------------------------------------------------------------------------
  describe('#readAllPlugins', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginDirectory.prototype.readAllPlugins, 'function')
    )
    it('Should return an error when there is no Jelly class bound', (cb) ->
      p = new PluginDirectory()
      p.readAllPlugins((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)        
      )
    )
    it('Should read all plugins in the local and general plugin directory', (cb) ->
      p = new PluginDirectory()
      jelly = new Jelly()
      p.setParent(jelly)
      jelly.setRootDirectory("#{__dirname}/testFiles/pluginLoading")
      p.readAllPlugins((err) ->
        if err?
          cb(err); cb = ->
          return
        cb()        
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#readPluginDirectory', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginDirectory.prototype.readPluginDirectory, 'function')
    )

    it('Should raise an error when a null value is passed as a directory', (cb) ->
      new PluginDirectory().readPluginDirectory(null, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )

    it('Should read a valid plugin directory', (cb) ->
      new PluginDirectory().readPluginDirectory("#{__dirname}/testFiles/pluginLoading/plugins", (err) ->
        try
          assert.equal(err, null)
          cb()
        catch e
          cb(e)
      )
    )

    it('Should raise an error if the directory specified do not exist', (cb) ->
      new PluginDirectory().readPluginDirectory("/do/not/exist", (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )

    it('Should raise an error if the directory specified is a file', (cb) ->
      new PluginDirectory().readPluginDirectory("#{__dirname}/testFiles/dummyFile.json", (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )

  )
#------------------------------------------------------------------------------------------
  describe('#readPluginFromPath', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginDirectory.prototype.readPluginFromPath, 'function')
    )
    it('Should raise an error when there null is given as a directory', (cb) ->
        p = new PluginDirectory()
        p.readPluginFromPath(null, "pluginName", (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
    )
    it('Should raise an error when there null is given as a name', (cb) ->
        new PluginDirectory().readPluginFromPath("#{__dirname}/testFiles/pluginLoading/plugins/testPlugin", null, (err, pluginHandler) ->
          try
            assert.equal(toType(err), 'error')
            assert.equal(pluginHandler, null)
            cb()
          catch e
            cb(e)
        )
    )
    it('Should load a plugin', (cb) ->
        new PluginDirectory().readPluginFromPath("#{__dirname}/testFiles/pluginLoading/plugins/testPlugin", "testPlugin", (err, pluginHandler) ->
          try
            assert.typeOf(pluginHandler, 'object')
            assert.equal(pluginHandler.PluginHandler, true)
          catch e
            cb(e); cb = ->
            return
          cb(err)
        )
    )

  )
#------------------------------------------------------------------------------------------
  describe('#applyPluginToJelly', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginDirectory.prototype.applyPluginToJelly, 'function')
    )
    it('Should raise an error when the recursive parameter is invalid', (cb) ->
      new PluginDirectory().applyPluginToJelly(null, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb(); cb = ->
        catch e
          cb(e)        
      )
    )
    it('Should raise an error when the recursive parameter is invalid', (cb) ->
      new PluginDirectory().applyPluginToJelly(null, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb(); cb = ->
        catch e
          cb(e)        
      )
    )
    it('Should raise an error when the recursive parameter is invalid', (cb) ->
      p = new PluginDirectory()
      jelly = new Jelly()
      p.setParent(jelly)
      p.applyPluginToJelly((err) ->
        cb()
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getPluginListFromIdList' , ->
    it('Should be a callable function', ->
      assert.typeOf(PluginDirectory.prototype.getPluginListFromIdList, 'function')
    )
    it('Should raise an error if the idList is not ad array', (cb) ->
      new PluginDirectory().getPluginListFromIdList('test', (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)        
      )
    )
    it('Should raise an error if some plugins cannot be found', (cb) ->
      dir = new PluginDirectory()
      handler = new PluginHandler()
      handler2 = new PluginHandler()
      handler.setId('test1')
      handler2.setId('test2')
      handler.setParent(dir)
      handler2.setParent(dir)
      dir.addChild(handler)
      dir.addChild(handler2)
      dir.getPluginListFromIdList(['test1', 'unknown', 'test2'], (err, list) ->
        try
          assert.equal(toType(err), 'error')
          assert.typeOf(list, 'array', 'it should return a list of working plugins even when there is an error')
          assert.equal(list.length, 2, 'it should return a list of working plugins even when there is an error')
          cb()
        catch e
          cb(e)        
      )
    )
    it('Should not raise an error if all plugins are found', (cb) ->
      dir = new PluginDirectory()
      handler = new PluginHandler()
      handler2 = new PluginHandler()
      handler.setId('test1')
      handler2.setId('test2')
      handler.setParent(dir)
      handler2.setParent(dir)
      dir.addChild(handler)
      dir.addChild(handler2)
      dir.getPluginListFromIdList(['test1', 'test2'], (err, list) ->
        try
          assert.equal(err, null)
          assert.typeOf(list, 'array', 'it should return a list of working plugins')
          assert.equal(list.length, 2, 'it should return a list of working plugins')
          cb()
        catch e
          cb(e)        
      )
    )   
  )
)