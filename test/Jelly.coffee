assert = require('chai').assert
async = require('async')
path = require('path')

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
)