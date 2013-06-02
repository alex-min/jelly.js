exports.implementing = (mixins..., classReference) ->
  classReference.__super__ ?= []


  for mixin in mixins
    #console.log mixin.prototype.ctor
    classReference.__super__.push(mixin)
    for key, value of mixin::
      if key != '_constructor_'
        classReference::[key] = value
      else
        classReference::_ctorList ?= []
        classReference::_ctorList.push(value)

  
  classReference::_parentConstructor_ = ->
    classReference::_ctorList ?= []
    for fct in classReference::_ctorList
      fct.call(this)


  classReference

extend = (obj, mixin) ->
  for name, method of mixin
    obj[name] = method

exports.include = (klass, mixin) ->
  extend klass.prototype, mixin

 