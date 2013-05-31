fs = require('fs')
path = require('path')

###*
 * RedeableEntity is an (almost) abstract class to deal with general content
 * The main goal of this class is to provide a way to retreive multiple versions of the same content (which was processed)
 * 
 * @class ReadableEntity
###
class ReadableEntity
  ReadableEntityCs: ->
    if !(@_cs)
      @_cs = true
      @_entityContentList = []

  constructor: -> @ReadableEntityCs()

  ReadableEntity: true

  ###*
   * Get the current state of the content
   *
   * @for ReadableEntity
   * @method getCurrentContent
   * @return {String} Current state of the content
  ###
  getCurrentContent: ->
    @ReadableEntityCs()

    @_entityContentList.slice(-1)[0] || {}

  ###*
   * Erase all the contents
   *
   * @for ReadableEntity
   * @method eraseContent
  ###
  eraseContent: ->
    @ReadableEntityCs()

    @_entityContentList ?= []
    @_entityContentList.length = 0


  ###*
   * Get the first content registred
   *
   * @for ReadableEntity
   * @method getFirstContent
   * @return first content registred
  ###
  getFirstContent: ->
    @ReadableEntityCs()

    @_entityContentList[0] || {}
  
  ###*
   * Get the list of content registred
   *
   * @for ReadableEntity
   * @method getContentList
   * @return list of content registred
  ###
  getContentList: ->
    @ReadableEntityCs()

    @_entityContentList

  ###*
   * Update the content stored
   *
   * @for ReadableEntity
   * @method updateContent
  ###
  updateContent: (content) ->
    @ReadableEntityCs()

    @_entityContentList.push(content)

  ###*
   * Update the content from a given file
   *
   * @for ReadableEntity
   * @method updateContent
  ###
  updateContentFromFile: (filename, encoding="utf8",cb) ->
    @ReadableEntityCs()
    self = @

    # handle additional parameters
    # because encoding is optional and the callback also, we need some tests
    cb = cb || encoding
    if typeof cb != 'function'
      cb = ->
    if typeof encoding != 'string'
      encoding = 'utf8'

    # read the file
    fs.readFile(filename, (err,content) ->
      try
        if err # we pass the error to the callback
          cb(err, null) ; cb = -> # call only the callback once
          return

        # file.js -> .js -> js
        extension = path.extname(filename).replace('.','')
        content = {
            filename:filename,
            content:content+'',
            extension:extension
        }

        # update the content (this is the purpose of the function)
        self.updateContent(content)
        cb(err,content) # callback
        cb = ->
      catch err
        cb(err, null)
    )


module.exports = ReadableEntity # export the class