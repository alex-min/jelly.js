###*
 * RedeableEntity is an (almost) abstract class to deal with general content
 * The main goal of this class is to provide a way to retreive multiple versions of the same content (which was processed)
 * 
 * @class ReadableEntity
###
class ReadableEntity
  constructor: ->
    @_entityContentList = []

  ###*
   * Get the current state of the content
   *
   * @for ReadableEntity
   * @method getCurrentContent
   * @return {String} Current state of the content
  ###
  getCurrentContent: -> @_entityContentList.slice(-1)[0] || {}

  ###*
   * Erase all the contents
   *
   * @for ReadableEntity
   * @method eraseContent
  ###
  eraseContent: ->
    @_entityContentList ?= []
    @_entityContentList.length = 0


  ###*
   * Get the first content registred
   *
   * @for ReadableEntity
   * @method getFirstContent
   * @return first content registred
  ###
  getFirstContent: -> @_entityContentList[0] || {}
  
  ###*
   * Get the list of content registred
   *
   * @for ReadableEntity
   * @method getContentList
   * @return list of content registred
  ###
  getContentList: -> @_entityContentList

  ###*
   * Update the content stored
   *
   * @for ReadableEntity
   * @method updateContent
  ###
  updateContent: (content) -> @_entityContentList.push(content)

module.exports = ReadableEntity # export the class