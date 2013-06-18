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
  describe('#_setDefaultContent', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginHandler.prototype._setDefaultContent, 'function')
    )
    it('Should set some default values', ->
      content = new PluginHandler()._setDefaultContent({})
      assert.typeOf(content, 'object')
      assert.equal(content.mainFile, 'main.js')
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
#------------------------------------------------------------------------------------------
  describe('#getPluginInterface', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginHandler.prototype.getPluginInterface, 'function')
    )
    it('Should return a pluginInterface instance', ->
      p = new PluginHandler()
      assert.typeOf(p.getPluginInterface(), 'object')
      assert.equal(p.getPluginInterface().constructor.name, 'PluginInterface', 'should be a pluginInterface type')
    )
    it('The pluginInterface instance should be a child of the PluginHandler', ->
      p = new PluginHandler()
      pInterface = p.getPluginInterface()
      p.__TEST__ = true
      parent = pInterface.getParent()
      assert.typeOf(parent, 'object')
      assert.equal(parent.constructor.name, 'PluginHandler')
      assert.equal(parent.__TEST__, true)
      assert.equal(p.getChildList().length, 1, 'the pluginInterface should be a child of the PluginHandler')
    )
  )
#------------------------------------------------------------------------------------------
  describe('#readMainEntryFile', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginHandler.prototype.readMainEntryFile, 'function')
    )
    it('Should raise an error when the directory is not loaded', (cb) ->
      new PluginHandler().readMainEntryFile((err, data) ->
        try
          assert.equal(data, null)
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)        
      )
    )
    it('Should raise an error when the configuration file is not loaded', (cb) ->
      p = new PluginHandler()
      p.updateContent({directory:__dirname})
      p.readMainEntryFile((err, data) ->
        try
          assert.equal(data, null)
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)        
      )
    )
    it('Should load the content from the content updated', (cb) ->
      p = new PluginHandler()
      p.updateContent({
          directory:"#{__dirname}/testFiles/pluginLoading/plugins/testPlugin"
          extension:'__exec'
          content:{}
        })
      p.readMainEntryFile((err, data) ->
        cb(err)      
      )
    )   
  )
#------------------------------------------------------------------------------------------
  describe('#reload', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginHandler.prototype.reload, 'function')
    )
    it('Should raise an error when there is no directory bound to the class', (cb) ->
      p = new PluginHandler()
      p.reload((err) ->
        try
          assert.equal(toType(err), 'error')
          cb(); cb = ->
        catch e
          cb(e)
      )
    )     
    it('Should reload plugins', (cb) ->
      p = new PluginHandler()
      p.updateContent({directory:"#{__dirname}/testFiles/pluginLoading/plugins/testPlugin"})
      p.reload((err) ->
        cb(err)        
      )
    )       
  )
)