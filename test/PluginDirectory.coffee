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
      new PluginDirectory().readPluginDirectory("#{__dirname}/testFiles/pluginLoading", (err) ->
        try
          assert.equal(err, null)
          cb()
        catch e
          cb(e)
      )      
    )
  )   
)