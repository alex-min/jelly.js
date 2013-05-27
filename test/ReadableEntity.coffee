assert = require('chai').assert

describe('ReadableEntity', ->
  ReadableEntity = require('../src/ReadableEntity');

  ## constructor
  describe('#constructor', ->
    it('creating a ReadableEntity should not throw errors', ->
      readableEntity = new ReadableEntity()
    )
  )

  ## getCurrentContent method
  describe('#getCurrentContent', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().getCurrentContent,"function")
    )
    it('Should return an empty object when nothing is set', ->
      readableEntity = new ReadableEntity()
      assert.equal(JSON.stringify(readableEntity.getCurrentContent()),"{}")
    )

    it('Should get the last content pushed', ->
      ## test with three contents
      readableEntity = new ReadableEntity()
      assert.typeOf(readableEntity.updateContent,"function","updateContent is not callable")
      readableEntity.updateContent({content:"Test1"})

      lastContent = readableEntity.getCurrentContent()
      assert.typeOf(lastContent, "object","updateContent did not return a valid content")
      assert.typeOf(lastContent.content, "string","updateContent returned the wrong content")
      assert.equal(lastContent.content, "Test1","updateContent returned the wrong content")

      readableEntity.updateContent({content:"Test2"})

      lastContent = readableEntity.getCurrentContent()
      assert.typeOf(lastContent, "object","updateContent did not return a valid content")
      assert.typeOf(lastContent.content, "string","updateContent returned the wrong content")
      assert.equal(lastContent.content, "Test2","updateContent returned the wrong content")
     
      readableEntity.updateContent({content:"Test3"})

      lastContent = readableEntity.getCurrentContent()
      assert.typeOf(lastContent, "object","updateContent did not return a valid content")
      assert.typeOf(lastContent.content, "string","updateContent returned the wrong content")
      assert.equal(lastContent.content, "Test3","updateContent returned the wrong content")     
    )
  )
)