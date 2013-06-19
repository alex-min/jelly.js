assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
Jelly = require('../src/Jelly');
GeneralConfiguration = require('../src/GeneralConfiguration');

describe('Module', ->
  Module = require('../src/Module')
  it('Should be a Module', ->
    assert.equal(Module.prototype.Module, true)
  )  
#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(Module.prototype._constructor_, 'function');
    )
  )

#------------------------------------------------------------------------------------------
  describe('#constructor', ->
    it('creating a Module instance should not throw errors', ->
      m = new Module()
    )
    it('Should extends from a Logger', ->
      assert.equal(Module.prototype.Logger, true)
    )
    it('Should extends from a ReadableEntity', ->
      assert.equal(Module.prototype.ReadableEntity, true)
    )
    it('Should extends from a TreeElement', ->
      assert.equal(Module.prototype.TreeElement, true)
    )
    it('Should extends from a PluginWrapper', ->
      assert.equal(Module.prototype.PluginWrapper, true)
    ) 
  )
#------------------------------------------------------------------------------------------
  describe('#loadFromFilename', ->
    it('Should be a callable function', ->
      assert.typeOf(Module.prototype.loadFromFilename, 'function')
    )
    it('Should return an error if the filename does not exist', (cb) ->
      try
        m = new Module()
        m.loadFromFilename('/do/not/exist/',(err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
      catch e
        cb(e)
    )
    it('Should set some default content on the module config file', (cb) ->
      try
        m = new Module()
        m.loadFromFilename("#{__dirname}/testFiles/empty.json",(err) ->
          try
            if err?
              cb(e); cb = ->
              return
            content = m.getLastExecutableContent()
            assert.typeOf(content, 'object')
            assert.typeOf(content.fileList, 'array')
            assert.typeOf(content.pathList, 'array')
            assert.typeOf(content.plugins, 'array')
            assert.typeOf(content.pluginParameters, 'object')
            assert.typeOf(content.modulePlugins, 'array')
            assert.typeOf(content.modulePluginParameters, 'object')
            assert.equal(content.fileList.length, 0)
            assert.equal(content.pathList.length, 0)
            assert.equal(content.plugins.length, 0)
            assert.equal(JSON.stringify(content.pluginParameters), '{}')
            assert.equal(content.modulePlugins.length, 0)
            assert.equal(JSON.stringify(content.modulePluginParameters), '{}')
            cb()
          catch e
            cb(e)
        )
      catch e
        cb(e)
    )
  )
#------------------------------------------------------------------------------------------
  describe('#reload', ->
    it('Should be a callable function', ->
      assert.typeOf(Module.prototype.reload, 'function')
    )
    it('Should send an error when there is no content loaded', (cb) ->
      try
        m = new Module()
        m.reload( (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
      catch e
        cb(e)
    )
    it('Should send an error when there is no Id bound to the module', (cb) ->
      try
        m = new Module()
        m.loadFromFilename("#{__dirname}/testFiles/empty.json", (err) ->
          try
            assert.equal(toType(err), 'error');
            cb()
          catch e
            cb(e)
        )
      catch e
        cb(e)
    )
    it('Should reload the content', (cb) ->
      try
        m = new Module()
        m.setId("pelos")
        m.loadFromFilename("#{__dirname}/testFiles/empty.json",(err) ->
          try
            assert.equal(err, null)
            m.updateContent({
              filename:"#{__dirname}/testFiles/dummyFile.json"
              content: {
                _test:true
              }
              extension:'__exec'
            })
            cb()
            return 
            m.reload((err) ->
              try
                content = m.getLastExecutableContent()
                assert.equal(content._test, true)
                assert.typeOf(content.plugins, 'array')
                cb()
              catch e
                cb(e)
            )
          catch e
            cb(e)
        )
      catch e
        cb(e)
    )
  )
)
