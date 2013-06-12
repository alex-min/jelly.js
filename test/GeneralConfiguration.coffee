assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
Jelly = require('../src/Jelly');

return;
describe('GeneralConfiguration', ->
  GeneralConfiguration = require('../src/GeneralConfiguration');
  it('Should be a GeneralConfiguration', ->
    assert.equal(GeneralConfiguration.prototype.GeneralConfiguration, true)
  )
#------------------------------------------------------------------------------------------
  describe('_constructor_', ->
    it('Should have a _constructor_', ->
      assert.typeOf(GeneralConfiguration.prototype._constructor_, 'function');
    )
  )

  describe('#constructor', ->
    it('creating a GeneralConfiguration instance should not throw errors', ->
      generalConfiguration = new GeneralConfiguration()
    )
    it('Should extends from a Logger', ->
      assert.equal(GeneralConfiguration.prototype.Logger, true)
    )
    it('Should extends from a ReadableEntity', ->
      assert.equal(GeneralConfiguration.prototype.ReadableEntity, true)
    )
    it('Should extends from a TreeElement', ->
      assert.equal(GeneralConfiguration.prototype.TreeElement, true)
    )
  )
#------------------------------------------------------------------------------------------
  describe('#readAllModules', ->
    it('Should be a callable function', ->
      assert.typeOf(GeneralConfiguration.prototype.readAllModules, 'function')
    )
    it('Should read all modules', (cb) ->
      try
        jelly = new Jelly()
        jelly.setRootDirectory("#{__dirname}/testFiles/validGeneralConfig")
        async.series([
          (cb) -> jelly.readJellyConfigurationFile( (err) -> cb(err,null)),
          (cb) -> jelly.readAllGeneralConfigurationFiles( (err) -> cb(err,null))
        ], (err, res) ->
          try
            assert.equal(err,null, 'files should be valid')
            assert.equal(jelly.getChildList().length, 1, 'there is only one generalConfiguration file in the validGeneralConfig directory')
            generalConfig = jelly.getChildList()[0]
            assert.equal(generalConfig.GeneralConfiguration, true, 'the child should be a GeneralConfiguration type')
            generalConfig.readAllModules((err) ->
              cb(err); cb = ->
            )  
          catch e
            cb(e) ; cb = ->        
        )
      catch e
        cb(e)
    )
    it('Should set default parameters if they do not exist', (cb) ->
      generalConfig = new GeneralConfiguration();
      generalConfig.setId('test.json')
      generalConfig.readUpdateAndExecute("#{__dirname}/testFiles/empty.json", 'utf8', (err) ->
        if err
          cb(err)
        else 
          generalConfig.readAllModules((err) ->
            if err
              cb(err) ; cb = ->
              return
            try
              content =  generalConfig.getLastExecutableContent()
              assert.equal(content.name, 'test', 'the default name should be the file without the json extension')
              assert.equal(content.moduleConfigurationFilename, 'assets.json')
              assert.typeOf(content.plugins, 'array')
              assert.equal(content.plugins.length, 0)
              assert.equal(toType(content.pluginParameters), 'object')
              assert.equal(JSON.stringify(content.pluginParameters), '{}')
              assert.typeOf(content.plugins, 'array')
              assert.equal(content.plugins.length, 0)
              cb()
            catch e
              cb(e)
          )
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#loadFromFilename', ->
    it('Should be a callable function', ->
      assert.typeOf(GeneralConfiguration.prototype.loadFromFilename, 'function')
    )
    it('Should return an error if there is no jelly object as parent', (cb) ->
      g = new GeneralConfiguration()
      g.loadFromFilename("#{__dirname}/testFiles/validGeneralConfig/conf/testConf1.json", (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )
    it('Should return an error if there is no jelly object as parent', (cb) ->
      g = new GeneralConfiguration()
      g.loadFromFilename("#{__dirname}/testFiles/validGeneralConfig/conf/testConf1.json", (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)        
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#reload', ->
    it('Should be a callable function', ->
      assert.typeOf(GeneralConfiguration.prototype.reload, 'function')
    )    
  )
)
