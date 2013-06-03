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
    cb = cb || ->

    # if it's not a TreeElement
    if typeof child != 'object' || Object.getPrototypeOf(child).TreeElement != true
      cb(new Error("The child class must inherits from a TreeElement"), null)
      return
    else
      @_childList.push(child)
      cb(null, child)
      return

module.exports = TreeElement # export the class