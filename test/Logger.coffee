assert = require('chai').assert
async = require('async')

describe('Logger', ->
  Logger = require('../src/Logger');
  #------------------------------------------------------------------------------------------
  ## constructor
  describe('#constructor', ->
    it('creating a Logger should not throw errors', ->
      logger = new Logger()
    )
  )
  it('Should be an instance of Logger', ->
      assert.equal(new Logger().Logger, true)
  )

  describe('#info', ->
    it('Should be a callable function', ->
      assert.typeOf(new Logger().info,"function")
    )
  )
  describe('#log', ->
    it('Should be a callable function', ->
      assert.typeOf(new Logger().log,"function")
    )
  )
  describe('#error', ->
    it('Should be a callable function', ->
      assert.typeOf(new Logger().error,"function")
    )
  )
  describe('#warn', ->
    it('Should be a callable function', ->
      assert.typeOf(new Logger().warn,"function")
    )
  )
)
