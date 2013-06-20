assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
File = require('../src/File')
Module = require('../src/Module')
PluginHandler = require('../src/PluginHandler')
Tools = require('../src/Tools')
ReadableEntity = require('../src/ReadableEntity')
TreeElement = require('../src/TreeElement')


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
  describe('#getPluginList', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginWrapper.prototype.getPluginList, 'function')
    )
    # -- #getPluginListFromObject
    it('Should raise an error when the object is not inherited from a TreeElement', (cb) ->
      A = Tools.implementing ReadableEntity, PluginWrapper, class _A
      class A
        _constructor_: ->  @_parentConstructor_();
        constructor: -> @_constructor_();
        ;
      new PluginWrapper().getPluginList((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should raise an error when the object is not inherited from a ReadableEntity', (cb) ->
      A = Tools.implementing TreeElement, PluginWrapper, class _A
      class A
        _constructor_: ->  @_parentConstructor_();
        constructor: -> @_constructor_();
        ;
      new PluginWrapper().getPluginList((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject    
    it('Should raise an error when there is no content', (cb) ->
      new PluginDirectory().getPluginListFromObject(new Module(), (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should return an empty array when there is no plugins', (cb) ->
      m = new Module()
      m.updateContent({
        content:{}
        extension:'__exec'
      })
      new PluginDirectory().getPluginListFromObject(m, (err, list) ->
        if err?
          cb(err); cb = ->
          return
        try
          assert.typeOf(list, 'array')
          assert.equal(list.length, 0)
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should raise an error when the file has no parent', (cb) ->
      f = new File()
      f.updateContent({
        content:{}
        extension:'__exec'
      })      
      new PluginDirectory().getPluginListFromObject(f, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should raise an error when the file has a parent module with no content', (cb) ->
      f = new File()
      f.updateContent({
        content:{}
        extension:'__exec'
      })
      m = new Module()
      m.addChild(f)
      f.setParent(m)
      new PluginDirectory().getPluginListFromObject(f, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should return an empty array when there is no plugins (on File objects)', (cb) ->
      f = new File()
      f.updateContent({
        content:{}
        extension:'__exec'
      })
      m = new Module()
      m.addChild(f)
      m.updateContent({
        content:{}
        extension:'__exec'
      })
      f.setParent(m)
      new PluginDirectory().getPluginListFromObject(f, (err, list) ->
        if err?
          cb(err); cb = ->
          return
        try
          assert.typeOf(list, 'array')
          assert.equal(list.length, 0)
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should return the plugin list (on File objects)', (cb) ->
      f = new File()
      f.updateContent({
        content:{}
        extension:'__exec'
      })
      m = new Module()
      m.addChild(f)
      m.updateContent({
        content:{plugins:['hello'], filePlugins:['world']}
        extension:'__exec'
      })
      f.setParent(m)
      new PluginDirectory().getPluginListFromObject(f, (err, list) ->
        if err?
          cb(err); cb = ->
          return
        try
          assert.typeOf(list, 'array')
          assert.equal(list.length, 1)
          assert.equal(list[0], 'world')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginListFromObject
    it('Should return the plugin list (on File objects)', (cb) ->
      m = new Module()
      m.updateContent({
        content:{plugins:['hello'], filePlugins:['world']}
        extension:'__exec'
      })
      new PluginDirectory().getPluginListFromObject(m, (err, list) ->
        if err?
          cb(err); cb = ->
          return
        try
          assert.typeOf(list, 'array')
          assert.equal(list.length, 1)
          assert.equal(list[0], 'hello')          
          cb()
        catch e
          cb(e)
      )
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
      p.setId('plugin')
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
          oncall: (obj, param, cb) ->
            console.log('TEST:ONCALL fired !')
            cb()
        },
        extension:'__exec'
      })

      file.applyPlugin(p, (err) ->
        cb(err)
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
    # ---------- #   
    it('Should raise an error when the pluginHandler does not have an id set', (cb) ->
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
        content: { oncall : (obj,param, cb) ->
          cb()
        },
        extension:'__exec'
      })

      file.applyPlugin(p, (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # ---------- #   
    it('Should set an empty array as pluginParameters by default on a File instance', (cb) ->
      p = new PluginHandler()
      p.setId('plugin')
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
          oncall: (obj, param, cb) ->
            try
              assert.typeOf(param, 'object')
              assert.equal(toType(param.pluginParameters), 'object')
              assert.equal(JSON.stringify(param.pluginParameters), '{}')
              cb()
            catch e
              cb(e)
        },
        extension:'__exec'
      })

      file.applyPlugin(p, (err) ->
        cb(err)
      )
    )
    # ---------- #   
    it('Should set an empty array as pluginParameters by default on a Other instances', (cb) ->
      p = new PluginHandler()
      p.setId('plugin')
      module = new Module()
      emptyFile = {
        content:{}
        extension:'__exec'
      }
      module.updateContent(emptyFile)
      p.updateContent(emptyFile)

      pluginInterface = p.getPluginInterface()
      pluginInterface.updateContent({
        content: {
          oncall: (obj, param, cb) ->
            try
              assert.typeOf(param, 'object')
              assert.equal(toType(param.pluginParameters), 'object')
              assert.equal(JSON.stringify(param.pluginParameters), '{}')
              cb()
            catch e
              cb(e)
        },
        extension:'__exec'
      })
      module.applyPlugin(p, (err) ->
        cb(err)
      )
    )    
  )
)