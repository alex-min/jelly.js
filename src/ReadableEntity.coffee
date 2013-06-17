fs = require('fs')
path = require('path')
async = require('async')

Events = require ('./Events')
Tools = require ('./Tools')
###*
 * RedeableEntity is an (almost) abstract class to deal with general content
 * The main goal of this class is to provide a way to retreive multiple versions of the same content (which was processed)
 * 
 * @class ReadableEntity
 * @extends Events
###
ReadableEntity = Tools.implementing Events, class _ReadableEntity
class ReadableEntity
  _constructor_: ->
    if !(@_cs)
      @_cs = true
      @_entityContentList = []

  constructor: -> @_constructor_()


  ###*
   * Get the current state of the content
   *
   * @for ReadableEntity
   * @method getCurrentContent
   * @return {String} Current state of the content
  ###
  getCurrentContent: ->
    return @_entityContentList.slice(-1)[0] || {}

  ###*
   * Get the current state of the content as an entity
   * This is the same thing as calling this.getCurrentContent().content
   *
   * @for ReadableEntity
   * @method getCurrentContentEntity
   * @return {String} Current state of the content (only the entity part)
  ###
  getCurrentContentEntity: ->
    return @getCurrentContent().content

  ###*
   * Erase all contents
   *
   * @for ReadableEntity
   * @method eraseContent
  ###
  eraseContent: ->
    @_entityContentList.length = 0


  ###*
   * Get the first content registred
   * -> Should return an empty object if nothing is set
   *
   * @for ReadableEntity
   * @method getFirstContent
   * @return first content registred
  ###
  getFirstContent: ->
    # should return an empty object if nothing is set
    return @_entityContentList[0] || {}
  
  ###*
   * Get the list of content registred
   *
   * @for ReadableEntity
   * @method getContentList
   * @return list of content registred
  ###
  getContentList: ->
    return @_entityContentList

  ###*
   * Get the last content of a given extension
   * Returns null if no content is found
   *
   * @for ReadableEntity
   * @method getLastContentOfExtension
   * @param {String} extension
   * @return last content of the given extension
  ###
  getLastContentOfExtension : (ext) ->
    # if the specified extension is invalid
    if typeof ext == 'undefined' || ext == null
      return null

    # for each content (decreasing iteration)
    for content in @_entityContentList by -1
      if content.extension == ext # if it has the right extension
        return content
    return null

  ###*
   * Get last executableContent
   * Equivalent to this.getLastContentOfExtension('__exec')
   * (__exec is the extension for executable js code)
   *
   * @for ReadableEntity
   * @method getLastExecutableContent
   * @param {String} extension
   * @return last content of the given extension (or null)
  ###
  getLastExecutableContent : ->
    content = @getLastContentOfExtension('__exec') || {}
    return content.content || null

  ###*
   * Get last known path of the content.
   * Search for a 'filename' property on each content pushed.
   * Should be equivalement of calling getLastOfProperty('filename',extFilter)
   *
   * @for ReadableEntity
   * @method getLastFilename
   * @param {String} [extFilter] If a null value is given, the function will search on any extension
   * , set a non-null value to use only a specified extension.
   * @return last content of the given extension (or null)
  ###
  getLastFilename : (extFilter) ->
    return @getLastOfProperty('filename',extFilter)

  ###*
   * Get last known directory of the content
   * Search for a 'directory' property on each content pushed
   * Should be equivalement of calling getLastOfProperty('directory',extFilter)
   
   * @for ReadableEntity
   * @method getLastDirectory
   * @param {String} [extFilter] If a null value is given, the function will search on any extension
   * , set a non-null value to use only a specified extension.
   * @return last directory pushed
  ###
  getLastDirectory : (extFilter) ->
    return @getLastOfProperty('directory',extFilter)

  ###*
   * Get last known property of the content.
   * Search for a property on each content pushed.
   * Returns null if no property are found.
   *
   * @for ReadableEntity
   * @method getLastOfProperty
   * @param {String} property Property name
   * @param {String} [extFilter] If a null value is given, the function will search on any extension
   * , set a non-null value to use only a specified extension.
   * @return last directory pushed
  ###
  getLastOfProperty: (property, extFilter) ->
    if typeof extFilter == 'undefined'
      extFilter = null

    # for each content (decreasing iteration)
    for content in @_entityContentList by -1
      # if it has the right extension
      # using null in this method means that any extension can be used
      if extFilter == null || content.extension == extFilter 
        if content[property]?
          return content[property]
    return null    


  ###*
   * Get the current content and try to eval it to execute it
   * This function can only handle 'json' or 'js' extensions and will return errors for everything else 
   * The content will be pushed as the currentContent.
   * Eval will be called for 'js' content and 'JSON.parse' for 'json' content  
   *
   * @for ReadableEntity
   * @async
   * @method updateAndExecuteCurrentContent
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
   * @param {Error} callback.content Content processed
  ###
  updateAndExecuteCurrentContent: (cb) ->
    try
      cb = cb || ->

      curContent = @getCurrentContent() # get the current content to execute it

      # There is no content
      if typeof curContent.content == 'undefined' || curContent.content == null
        cb(new Error("There is no content on the stack to execute"), null); cb = ->;
        return
      # There is no extension for the content
      if typeof curContent.extension == 'undefined' || curContent.extension == null
        cb(new Error('The last content on the stack do not have any' + \ 
        ' extension associated, it might not be executable')); cb = ->;
        return
      # The extension cannot be executed in a javascript environment
      if curContent.extension != 'json' && curContent.extension != 'js'
        cb(new Error("Only 'json' and 'js' content can be executed" + \
          ", the current stack has an extension of #{curContent.extension}"), null); cb = ->
        return

      # executing the content according to the extension
      execContent = null
      try
        switch curContent.extension
          when 'json' then execContent = JSON.parse(curContent.content)
          when 'js' then execContent = eval(curContent.content)
      catch e
        cb(new Error("Unable to parse content #{curContent.content}, #{e} on file #{curContent.filename}"), null); cb = ->
        return

      # the executable extension is __exec
      content = {
        extension:'__exec',
        content: execContent
      }

      # we update the content to what we have interpreted
      @updateContent(content)
      cb(null, content); cb = ->
    catch e
      cb(e, null); cb = ->

  ###*
   * Update content from a file and execute it after
   * Equivalent of calling updateContentFromFile and updateAndExecuteCurrentContent methods.
   * @for ReadableEntity
   * @method readUpdateAndExecute
   * @async
   * @param {String} fileLocation the location of the file to read
   * @param {String} encoding Encoding of the file (default:utf8)  
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution
  ###
  readUpdateAndExecute: (fileLocation, encoding, cb) ->
    cb = cb || ->

    self = @
    try
      async.series([
        # update the content first
        (cb) ->
          try
            self.updateContentFromFile(fileLocation, 'utf8', (err, res) ->
              if err
                cb(err, null)
              else
                cb(null, null)
            )
          catch e
            cb(e)
        # and try to interpret it after
        (cb) ->
          try
            self.updateAndExecuteCurrentContent((err) -> cb(err))
          catch e
            cb(e)
      ], (err) ->
        cb(err); cb = ->
      )
    catch e
      cb(e); cb = ->


  ###*
   * Update the content stored
   * The content will be considered as the current content.
   *
   * @for ReadableEntity
   * @param content Content to push on the list of content stored
   * @method updateContent
  ###
  updateContent: (content) ->
    @_entityContentList.push(content)

  ###*
   * Update the content from a local file
   *
   * @for ReadableEntity
   * @method updateContentFromFile
   * @async
   * @param {String} filename The file location
   * @param {String} encoding The encoding of the file, the encoding is the same as node's fs.readFile
   * @param {Function}[callback] callback function
   * @param {Error} callback.err Error found during execution   
   * @param {String} callback.content The content of the file 
  ###
  updateContentFromFile: (filename, encoding="utf8",cb) ->
    try
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
          if err? # we pass the error to the callback
            cb(err, null) ; cb = -> # call only the callback once
            return

          # file.js -> .js -> js
          extension = path.extname(filename).replace('.','')
          content = {
              filename:filename,
              content:content+'', # transform a Nodejs Buffer object into a string
              extension:extension
          }
          # update the content (this is the purpose of the function)
          self.updateContent(content)
          cb(err,content) # callback
          cb = ->
        catch err
          cb(err, null)
      )
    catch e
      cb(e); cb = ->


module.exports = ReadableEntity # export the class