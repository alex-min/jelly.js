assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  


describe('Jelly', ->
  Jelly = require('../src/Jelly');

#------------------------------------------------------------------------------------------
  describe('#constructor', ->
    it('creating a Jelly instance should not throw errors', ->
      jelly = new Jelly()
    )
    it('Jelly should inherits from a Logger', ->
      assert.equal(Jelly.prototype.Logger, true)
    )
    it('Jelly should inherits from a ReadableEntity', ->
      assert.equal(Jelly.prototype.ReadableEntity, true)
    )
    it('should extends from a ReadableEntity', ->
      assert.equal(Jelly.prototype.TreeElement, true)
    )
    it('Should extends from a PluginWrapper', ->
      assert.equal(Jelly.prototype.PluginWrapper, true)
    )    
  )

#------------------------------------------------------------------------------------------
  describe('#getLocalPath', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.getLocalPath,"function")
    )
    it('Should be equivlent of getRootDirectory() + / + path', ->
       jelly = new Jelly()
       Path = 'a/b/c/d'
       assert.equal("#{jelly.getRootDirectory()}/#{Path}", jelly.getLocalPath(Path));
       jelly.setRootDirectory('e/f/g/h')
       assert.equal("#{jelly.getRootDirectory()}/#{Path}", jelly.getLocalPath(Path));       
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getRootDirectory', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.getRootDirectory,"function")
    )
    it('Should return __dirname by default', ->
      jelly = new Jelly()
      dirname = path.normalize("#{__dirname}/../src")
      assert.equal(jelly.getRootDirectory(), dirname, "the directory should be __dirname");
    )
    it('Should get the current root directory', ->
      jelly = new Jelly()
      jelly.setRootDirectory('a')
      assert.equal(jelly.getRootDirectory(), 'a', 'the current root directory is not what specified');
      jelly.setRootDirectory('b')
      assert.equal(jelly.getRootDirectory(), 'b', 'the current root directory is not what specified');
    )
  )

#------------------------------------------------------------------------------------------
  describe('#setRootDirectory', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.getRootDirectory,"function")
    )
    ## enough tests were done in getRootDirectory, no need to add others
  )

#------------------------------------------------------------------------------------------
  describe('#checkRootDirectory', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.checkRootDirectory, 'function')
    )
    it('Should return an error if the root directory do not exist', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("/a/b/c/d")
      jelly.checkRootDirectory( (err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )      
    )
    it('Should return an error if  the root directory is not a directory', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/dummyFile.txt")
      jelly.checkRootDirectory( (err) ->
        try
          assert.equal(toType(err), 'error')
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should not throw errors on a valid root directory', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/validJellyConfFile")
      jelly.checkRootDirectory( (err) ->
        try
          assert.equal(err, null);
          cb(); cb = ->      
        catch e
          cb(e); cb = ->
      )
    )    
  )
#------------------------------------------------------------------------------------------
  describe('#readJellyConfigurationFile', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.readJellyConfigurationFile, 'function')
    )
    it('Should return an error if the /conf directory do not exist', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("/a/b/c/d")
      jelly.readJellyConfigurationFile( (err, content) ->
        try
          assert.equal(toType(err), 'error')
          assert.equal(content, null)
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should return an error if  /conf is not a directory', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/emptyConfFile")
      jelly.readJellyConfigurationFile( (err, content) ->
        try
          assert.equal(toType(err), 'error')
          assert.equal(content, null)
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should return an error if /conf/JellyConf.json do not exist', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/emptyConfFolder")
      jelly.readJellyConfigurationFile( (err, content) ->
        try
          assert.equal(toType(err), 'error')
          assert.equal(content, null)
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should return the content read', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/validJellyConfFile")
      jelly.readJellyConfigurationFile( (e, content) ->
        try
          assert.equal(e, null)
          assert.typeOf(content, 'object')
          assert.equal(content.content, '{"test":true}')
          assert.equal(content.extension, 'json')

          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should push a __exec content on the ReadableEntity object', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/validJellyConfFile")
      jelly.readJellyConfigurationFile( (e, content) ->
        try
          ct = jelly.getCurrentContent()
          assert.equal(ct.extension, '__exec')
          assert.typeOf(ct.content, 'object')
          assert.equal(ct.content.test, true) # because the file contains {"test":true}
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
  )
#------------------------------------------------------------------------------------------
  describe('#readAllGeneralConfigurationFiles', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.readAllGeneralConfigurationFiles, 'function')
    )
    it('Should return an error when there is no executable content available', (cb) ->
      jelly = new Jelly()
      jelly.readAllGeneralConfigurationFiles((err) ->
        try
          assert.equal(toType(err), 'error')
          cb(); cb = ->
        catch e
          cb(e); cb = ->
      )
    )
    it('Should read all general configuration file', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/validGeneralConfig")
      async.series([
        (cb) -> jelly.readJellyConfigurationFile( (err) -> cb(err,null)),
        (cb) -> jelly.readAllGeneralConfigurationFiles( (err) -> cb(err,null))
      ], (err, res) ->
        try
          assert.equal(err,null, 'files should be valid')
          cb()
        catch e
          cb(e)        
      )
    )    
  )
#------------------------------------------------------------------------------------------
  describe('#getPluginDirectory', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.getPluginDirectory, 'function')
    )
    it('Should return getRootDirectory() + /plugins', ->
      j = new Jelly()
      j.setRootDirectory('a/b/c')
      assert.equal(j.getPluginDirectory(), "#{j.getRootDirectory()}/plugins")
      j.setRootDirectory('/d/e/f/g/test')
      assert.equal(j.getPluginDirectory(), "#{j.getRootDirectory()}/plugins")
    )    
  )  
)