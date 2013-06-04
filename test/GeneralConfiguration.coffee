assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  

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
)
