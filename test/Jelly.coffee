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
      assert.equal(Jelly.prototype.Logger, true);
    )
    it('Jelly should inherits from a ReadableEntity', ->
      assert.equal(Jelly.prototype.ReadableEntity, true);
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

  describe('#readJellyConfigurationFile', ->
    it('Should be a callable function', ->
      assert.typeOf(Jelly.prototype.readJellyConfigurationFile, 'function')
    )
    it('Should return an error if the /conf directory do not exist', (cb) ->
      jelly = new Jelly()
      jelly.readJellyConfigurationFile( (err, content) ->
        assert.equal(toType(err), 'error')
        assert.equal(content, null)
        cb()
      )
    )
    it('Should return an error if  /conf is not a directory', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/emptyConfFile")
      jelly.readJellyConfigurationFile( (err, content) ->
        assert.equal(toType(err), 'error')
        assert.equal(content, null)
        cb()
      )
    )
    it('Should return an error if /conf/JellyConf.json do not exist', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/emptyConfFolder")
      jelly.readJellyConfigurationFile( (err, content) ->
        assert.equal(toType(err), 'error')
        assert.equal(content, null)
        cb()
      )
    )
    it('Should push JellyConf content into the ReadableEntity methods', (cb) ->
      jelly = new Jelly()
      jelly.setRootDirectory("#{__dirname}/testFiles/validJellyConfFile")
      jelly.readJellyConfigurationFile( (e, content) ->
        assert.equal(e, null)
        assert.typeOf(content, 'object')
        assert.equal(content.content, '{}')
        assert.equal(content.extension, 'json')
        cb()
        # if a strange error is showing up on mocha, that means that a test is wrong
        # the callback can be fired twice due to this bug (there is no way to do a better catch)
      )
    )
  )
)