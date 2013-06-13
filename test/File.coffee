assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  
Jelly = require('../src/Jelly');

describe('File', ->
  File = require('../src/File');
  it('Should be a File', ->
    assert.equal(File.prototype.File, true)
  )
#------------------------------------------------------------------------------------------  
  describe('#constructor', ->
    it('creating an instance should not throw errors', ->
      file = new File()
    )
    it('Should extends from a Logger', ->
      assert.equal(File.prototype.Logger, true)
    )
    it('Should extends from a ReadableEntity', ->
      assert.equal(File.prototype.ReadableEntity, true)
    )
    it('Should extends from a TreeElement', ->
      assert.equal(File.prototype.TreeElement, true)
    )
  )  
#------------------------------------------------------------------------------------------
  describe('#loadFromFilename', ->
    it('Should be a callable function', ->
      assert.typeOf(File.prototype.loadFromFilename, 'function')
    )

    it('Should return an error if the file does no exist', (cb) ->
      file = new File()
      file.loadFromFilename('/do/not/exist',(err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )
    )

    it('Should load a file from its filename', (cb) ->
      file = new File()
      file.loadFromFilename("#{__dirname}/testFiles/dummyFIle.json",(err) ->
        cb(err)
      )      
    ) 
  )
)