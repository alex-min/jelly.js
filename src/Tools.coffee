exports.implementing = (mixins..., classReference) ->
  for mixin in mixins
    for key, value of mixin::
      classReference::[key] = value
  classReference

extend = (obj, mixin) ->
  for name, method of mixin
    obj[name] = method

exports.include = (klass, mixin) ->
  extend klass.prototype, mixin

 