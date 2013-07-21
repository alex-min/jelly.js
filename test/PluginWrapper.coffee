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
GeneralConfiguration = require('../src/GeneralConfiguration')
Jelly = require('../src/Jelly')

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
    # -- #getPluginList
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
    # -- #getPluginList    
    it('Should raise an error when there is no content', (cb) ->
      new Module().getPluginList((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginList
    it('Should return an empty array when there is no plugins', (cb) ->
      m = new Module()
      m.updateContent({
        content:{}
        extension:'__exec'
      })
      m.getPluginList((err, list) ->
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
    # -- #getPluginList
    it('Should raise an error when the file has no parent', (cb) ->
      f = new File()
      f.updateContent({
        content:{}
        extension:'__exec'
      })      
      f.getPluginList( (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginList
    it('Should raise an error when the file has a parent module with no content', (cb) ->
      f = new File()
      f.updateContent({
        content:{}
        extension:'__exec'
      })
      m = new Module()
      m.addChild(f)
      f.setParent(m)
      f.getPluginList((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    # -- #getPluginList
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
      f.getPluginList((err, list) ->
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
    # -- #getPluginList
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
      f.getPluginList((err, list) ->
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
    # -- #getPluginList
    it('Should return the plugin list (on File objects)', (cb) ->
      m = new Module()
      m.updateContent({
        content:{plugins:['hello'], filePlugins:['world']}
        extension:'__exec'
      })
      m.getPluginList((err, list) ->
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
  describe('#applyPlugin', ->
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
              assert.equal(toType(param.pluginParameters.plugin), 'object')
              assert.equal(JSON.stringify(param.pluginParameters.plugin), '{}')
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
              assert.equal(toType(param.pluginParameters.plugin), 'object')
              assert.equal(JSON.stringify(param.pluginParameters.plugin), '{}')
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
  describe('#applyPluginsSpecified', ->
    it('Should be a callable function', ->
      assert.typeOf(PluginWrapper.prototype.applyPluginsSpecified, 'function')
    )
    it('Should return an error if the recursive parameter is not boolean', (cb) ->
      new PluginWrapper().applyPluginsSpecified('test', (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)        
      )
    )
    it('The recursive param should be optional', (cb) ->
      new PluginWrapper().applyPluginsSpecified((err) ->
        try
          assert.equal(toType(err), 'error','the class must extends from a TreeElement')
          cb()
        catch e
          cb(e)
      )
    )
    it('Should have a jelly parent', (cb) ->
      new GeneralConfiguration().applyPluginsSpecified((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    it('Should work on a non-recursive way', (cb) ->
      g = new GeneralConfiguration()
      jelly = new Jelly()
      g.setParent(jelly)
      jelly.addChild(g)
      g.updateContent({
        content:{
          plugins:['testPlugin','testPlugin2']
        }
        extension:'__exec'
      })
      jelly.setRootDirectory("#{__dirname}/testFiles/pluginLoading")
      jelly.getPluginDirectoryList().readAllPlugins((err) ->
        if err?
          cb(err); cb = ->
          return
        g.applyPluginsSpecified(false, (err) ->
          cb(err)
        )
      )
    )
    it('Should get the plugins paramets', (cb) ->
      g = new GeneralConfiguration()
      jelly = new Jelly()
      g.setParent(jelly)
      jelly.addChild(g)
      g.updateContent({
        content:{
          plugins:['paramPlugin']
          pluginParameters:{'paramPlugin':{'TEST':1}}
        }
        extension:'__exec'
      })
      jelly.setRootDirectory("#{__dirname}/testFiles/pluginParametersLoading")
      jelly.getPluginDirectoryList().readAllPlugins((err) ->
        if err?
          cb(err); cb = ->
          return
        g.applyPluginsSpecified(false, (err) ->
          cb(err)
        )
      )
    )    
    it('Should raise an error if any plugin does not exist', (cb) ->
      g = new GeneralConfiguration()
      jelly = new Jelly()
      g.setParent(jelly)
      jelly.addChild(g)
      g.updateContent({
        content:{
          plugins:['testPlugin','testPlugin2', 'DO_NOT_EXIST']
        }
        extension:'__exec'
      })
      jelly.setRootDirectory("#{__dirname}/testFiles/pluginLoading")
      jelly.getPluginDirectoryList().readAllPlugins((err) ->
        if err?
          cb(err); cb = ->
          return
        g.applyPluginsSpecified(false, (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
      )
    )

    it('Should raise an error if any child plugin does not exist', (cb) ->
      g = new GeneralConfiguration()
      module = new Module()
      file = new File()
      jelly = new Jelly()

      g.setParent(jelly)
      jelly.addChild(g)
      g.updateContent({
        content:{
          plugins:['testPlugin','testPlugin2']
        }
        extension:'__exec'
      })
      module.updateContent({
        content: {
          plugins:['testPlugin', 'testPlugin2', 'PLUGIN_DO_NOT_EXIST']
        }
        extension:'__exec'
      })
      module.addChild(file)
      file.setParent(module)
      g.addChild(module)
      module.setParent(g)
      jelly.setRootDirectory("#{__dirname}/testFiles/pluginLoading")
      jelly.getPluginDirectoryList().readAllPlugins((err) ->
        if err?
          cb(err); cb = ->
          return
        g.applyPluginsSpecified(true, (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
      )
    )
    # ----
    it('Should raise an error if any child plugin does not exist [File object]', (cb) ->
      g = new GeneralConfiguration()
      module = new Module()
      file = new File()
      jelly = new Jelly()

      g.setParent(jelly)
      jelly.addChild(g)
      g.updateContent({
        content:{
          plugins:['testPlugin','testPlugin2']
        }
        extension:'__exec'
      })
      module.updateContent({
        content: {
          plugins:['testPlugin', 'testPlugin2']
          filePlugins:['DO_NOT_EXIST']
        }
        extension:'__exec'
      })
      module.addChild(file)
      file.setParent(module)
      g.addChild(module)
      module.setParent(g)
      jelly.setRootDirectory("#{__dirname}/testFiles/pluginLoading")
      jelly.getPluginDirectoryList().readAllPlugins((err) ->
        if err?
          cb(err); cb = ->
          return
        g.applyPluginsSpecified(true, (err) ->
          try
            assert.equal(toType(err), 'error')
            cb()
          catch e
            cb(e)
        )
      )
    )
  )
)