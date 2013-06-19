assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
File = require('../src/File')
Module = require('../src/Module')
PluginHandler = require('../src/PluginHandler')


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
  describe('constructor', ->
    it('Should raise no error when creating a new instance', ->
      new PluginWrapper()
    )
  )
#------------------------------------------------------------------------------------------
  describe('applyPlugin', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginWrapper.prototype.applyPlugin, 'function')
    )
    # ---------- #
    it('Should raise an error when the plugin is invalid', (cb) ->
      new PluginWrapper().applyPlugin({}, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # ---------- #
    it('Should raise an error when the plugin is invalid', (cb) ->
      new PluginWrapper().applyPlugin({}, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # ---------- #
    it('Should be used only on a class extending from ReadableEntity', (cb) ->
      p = new PluginWrapper()
      p.PluginHandler = true;
      p.applyPlugin(p, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # ---------- #
    it('Should raise an error when used with a File with no parent', (cb) ->
      p = new PluginHandler()
      file = new File()
      file.applyPlugin(p, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # ---------- #
    it('Should raise an error when used with a File with a parent module with no content', (cb) ->
      p = new PluginHandler()
      file = new File()
      module = new Module()
      file.setParent(module)
      file.applyPlugin(p, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # ---------- #    
    it('Should apply the plugin to a File instance', (cb) ->
      p = new PluginHandler()
      file = new File()
      module = new Module()
      file.setParent(module)
      emptyFile = {
        content:{}
        extension:'__exec'
      }
      module.updateContent(emptyFile)
      p.updateContent(emptyFile)

      pluginInterface = p.getPluginInterface()
      pluginInterface.updateContent({
        content: {
          oncall: ->
            console.log('TEST:ONCALL fired !')
            cb()
        },
        extension:'__exec'
      })

      file.applyPlugin(p, (err) ->
        try
          assert.equal(toType(err), 'error')
        catch e
          cb(e)
      )
    )
    # ---------- #
    it('Should raise an error when there is no content', (cb) ->
      p = new PluginHandler()
      module = new Module()
      module.applyPlugin(p, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )          
  )
)