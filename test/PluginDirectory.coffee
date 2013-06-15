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
        new PluginDirectory().readPluginFromPath(null, "pluginName", (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
    )
    it('Should raise an error when there null is given as a name', (cb) ->
        new PluginDirectory().readPluginFromPath("#{__dirname}/testFiles/pluginLoading/plugins/testPlugin", null, (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
    )
    it('Should load a plugin', (cb) ->
        new PluginDirectory().readPluginFromPath("#{__dirname}/testFiles/pluginLoading/plugins/testPlugin", "testPlugin", (err) ->
          cb(err)
        )
    )

  )
)