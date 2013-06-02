assert = require('chai').assert
async = require('async')
path = require('path')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  

describe('GeneralConfiguration', ->
  GeneralConfiguration = require('../src/GeneralConfiguration');

)
