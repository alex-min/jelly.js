###*
 * TreeElement is a class for dealing with the architecture of the web framework.
 * It helps to handle the hierarchy of [Jelly] -> [GeneralConfiguration] -> [Module] -> [File] 
 * 
 * @class TreeElement
###
class TreeElement
  TreeElement: true
  constructor: -> @_constructor_()
  _constructor_: ->
    @_childList = []
    @_parent = null
    @_id = null


  ###*
   * This method will return set the Id returned by the method TreeElement::getId
   * The main goal is to provide an easy system to find node in TreeElements
   * The default id is set to null.
   * Any call to setId will replace the previous id without further check.
   *
   * @for TreeElement
   * @method setId
   * @param {Any Type} Id of the element (or null)
  ###
  setId: (_id) -> @_id = _id

  ###*
   * This method will return the Id set by the method TreeElement::setId
   * The main goal is to provide an easy system to find node in TreeElements
   * The default id is set to null.
   *
   * @for TreeElement
   * @method getId
   * @return {Any Type} Id of the element (or null)
  ###
  getId: -> @_id

  ###*
   * This method will find a child by its Id.
   * If nothing is found, the method will return null.
   * Any null id passed to the method will result in a null return without any further research.
   *
   * @for TreeElement
   * @method getChildById
   * @param {Any Type} Searched id
   * @param {TreeElement} Child found by the id (or null)
  ### 
  getChildById: (id) ->
    # if the key is invalid, return null
    return null if typeof id == 'undefined' || id == null

    for child in @_childList
      # if the child has the right key
      if child.getId() == id
        return child
    return null # we found nothing

  ###*
   * Get the list of children (the list should consist of TreeElement classes).
   * This function should return an empty array when nothing is set.
   *
   * @for TreeElement
   * @method getChildList
   * @return {TreeElement[]} Array of TreeElements
  ### 
  getChildList: -> @_childList

  ###*
   * Get the parent of the element (there is only one parent per TreeElement)
   * This function should return null when nothing is set.
   *
   * @for TreeElement
   * @method getParent
   * @return {TreeElement} Parent element
  ###   
  getParent: -> @_parent

  getParentOfClass: (className) ->
    if typeof className != 'string'
      return null
    currentObj = this
    while 1
      if currentObj == null || Object.getPrototypeOf(currentObj)[className] == true
        return currentObj
      currentObj = currentObj.getParent()
    ;

  getParentOfLevel: (level) ->
    if typeof level != 'number'
      return null
    if level == 0
      return this
    i = 1
    currentObj = this
    parent = null
    while i < level
      parent = currentObj.getParent()
      if parent == null
        return null
      i++
    return parent

  ###*
   * Set the parent of the element (there is only one parent per TreeElement)
   * This function should return null in its callback when everything is ok.
   * The parent element must inherits from a TreeElement, this will be checked in the function.
   * In the case of an invalid element, an error will be returned in the callback.
   * The error will be a Javacript native Error.
   * Any existing parent will be replaced when calling this method.
   *
   * @for TreeElement
   * @method setParent
   * @param {TreeElement} New parent of the element
   * @param {Function} callback. Params returned : (err : Errors when setting the new parent). 
  ###
  setParent : (parent, cb) ->
    cb = cb || ->

    # if it's not a TreeElement  
    if typeof parent != 'object' || Object.getPrototypeOf(parent).TreeElement != true
      cb(new Error("The parent class must inherits from a TreeElement"))
    else
      @_parent = parent
      cb(null)

  ###*
   * Add a new child to the child list
   * The parent element must inherits from a TreeElement, this will be checked in the function.
   * In the case of an invalid element, an error will be returned in the callback.
   * The error will be a Javacript native Error.
   * If the child is already in the list, only one instance will be added.
   *
   * @for TreeElement
   * @method addChild
   * @param {TreeElement} Element to add to the child list.
   * @param {Function}[callback]. Callback function
   * @param {Error}. Errors found when executing the method (or null)
   * @param {TreeElement}. The TreeElement sent before on the callback.
   * In the case of an error, null will be returned.
  ###      
  addChild: (child, cb) ->

    # if it's not a TreeElement
    if typeof child != 'object' || Object.getPrototypeOf(child).TreeElement != true
      err = new Error("The child class must inherits from a TreeElement")
      if cb?
        cb(err, null)
      else
        throw err
    else
      cb = cb || ->
      # if the child is already pushed, we do not push it
      if @getChildById(child.getId()) != null
        cb(null, child); cb = ->
        return
      @_childList.push(child)
      cb(null, child)
      return

module.exports = TreeElement # export the class