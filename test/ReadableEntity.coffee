assert = require('chai').assert
async = require('async')
toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()  

describe('ReadableEntity', ->
  ReadableEntity = require('../src/ReadableEntity');

#------------------------------------------------------------------------------------------
  ## constructor
  describe('#constructor', ->
    it('creating a ReadableEntity should not throw errors', ->
      readableEntity = new ReadableEntity()
    )
  )
#------------------------------------------------------------------------------------------
  describe('#updateAndExecuteCurrentContent', ->
    it('Should be a callable function', ->
      assert.typeOf(ReadableEntity.prototype.updateAndExecuteCurrentContent, 'function')
    )
    it('Should return an error if there is no content', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateAndExecuteCurrentContent((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )  
    )
    it('Should return an error if the current content has no extension', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'A'})
      readableEntity.updateAndExecuteCurrentContent((err) ->
        try
          assert.equal(toType(err), 'error')
          cb()
        catch e
          cb(e)
      )  
    )
    it('Should return an error if the current content has an extension which does not allow execution', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'A', extension:'invalid'})
      readableEntity.updateAndExecuteCurrentContent((err, content) ->
        try
          assert.equal(toType(err), 'error')
          assert.equal(content, null)
          cb()
        catch e
          cb(e)
      )  
    )
    it('Should throw an error with an invalid json', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'INVALID JSON', extension:'json'})
      readableEntity.updateAndExecuteCurrentContent((err, content) ->
        try
          assert.equal(toType(err), 'error')
          assert.equal(content, null)
          cb()
        catch e
          cb(e)
      )  
    )
    it('Should push a content with and __exec extension if everything is valid', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'{"valid":true}', extension:'json'})
      readableEntity.updateAndExecuteCurrentContent((err, content) ->
        try
          contentCheck = (content) ->
            assert.equal(toType(err), 'null')
            assert.equal(toType(content), 'object')
            assert.equal(content.extension, '__exec')
            assert.typeOf(content.content, 'object')
            assert.equal(content.content.valid, true)
          contentCheck(content)
          contentPushed = readableEntity.getCurrentContent()
          contentCheck(contentPushed)
          cb()
        catch e
          cb(e)
      )  
    )
  )
#------------------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------------------
  describe('#getCurrentContentEntity', ->
    it('Should be a callable function', ->
      assert.typeOf(ReadableEntity.prototype.getCurrentContentEntity,"function")
    )
    it('Should return an null when nothing is set', ->
      readableEntity = new ReadableEntity()
      assert.equal(readableEntity.getCurrentContentEntity(),null)
    )
    it('Should get the last string content pushed', ->
      ## test with three contents
      readableEntity = new ReadableEntity()
      assert.typeOf(readableEntity.updateContent,"function","updateContent is not callable")
      readableEntity.updateContent({content:"Test1"})

      lastContent = readableEntity.getCurrentContentEntity()
      assert.equal(lastContent, "Test1","updateContent returned the wrong content")

      readableEntity.updateContent({content:"Test2"})

      lastContent = readableEntity.getCurrentContentEntity()
      assert.equal(lastContent, "Test2","updateContent returned the wrong content")
     
      readableEntity.updateContent({content:"Test3"})

      lastContent = readableEntity.getCurrentContentEntity()
      assert.equal(lastContent, "Test3","updateContent returned the wrong content")     
    )
  )
#------------------------------------------------------------------------------------------
  # eraseContent method
  describe('#eraseContent', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().eraseContent,"function")
    )
    it('Should do nothing if nothing is set', ->
      readableEntity = new ReadableEntity()
      assert.typeOf(readableEntity.updateContent,"function","updateContent is not callable")
      readableEntity.eraseContent()
      assert.equal(JSON.stringify(readableEntity.getCurrentContent()),"{}")      
    )
    it('Should erase content when called', ->
      readableEntity = new ReadableEntity()

      # we push some content
      assert.typeOf(readableEntity.updateContent,"function","updateContent is not callable")
      readableEntity.updateContent({content:"Test1"})
      readableEntity.updateContent({content:"Test2"})
      lastContent = readableEntity.getCurrentContent()
      assert.equal(lastContent.content, "Test2","updateContent returned the wrong content")
      
      #now we erase everything
      readableEntity.eraseContent()

      # we test if the content is erased
      lastContent = readableEntity.getCurrentContent()
      assert.equal(JSON.stringify(lastContent),"{}","content is not erased")
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getFirstContent', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().getFirstContent,"function")
    )
    it('Should return an empty object when nothing is set', ->
      readableEntity = new ReadableEntity()
      assert.equal(JSON.stringify(readableEntity.getFirstContent()),"{}")
    )
    it('Should get the first content pushed', ->
      ## test with three contents
      readableEntity = new ReadableEntity()
      assert.typeOf(readableEntity.updateContent,"function","updateContent is not callable")
      readableEntity.updateContent({content:"Test1"})

      lastContent = readableEntity.getFirstContent()
      assert.typeOf(lastContent, "object","updateContent did not return a valid content")
      assert.typeOf(lastContent.content, "string","updateContent returned the wrong content")
      assert.equal(lastContent.content, "Test1","updateContent returned the wrong content")

      readableEntity.updateContent({content:"Test2"})

      lastContent = readableEntity.getFirstContent()
      assert.typeOf(lastContent, "object","updateContent did not return a valid content")
      assert.typeOf(lastContent.content, "string","updateContent returned the wrong content")
      assert.equal(lastContent.content, "Test1","updateContent returned the wrong content")
     
      readableEntity.updateContent({content:"Test3"})

      lastContent = readableEntity.getFirstContent()
      assert.typeOf(lastContent, "object","updateContent did not return a valid content")
      assert.typeOf(lastContent.content, "string","updateContent returned the wrong content")
      assert.equal(lastContent.content, "Test1","updateContent returned the wrong content")     
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getContentList', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().getContentList,"function")
    )
    it('Should return an empty array when nothing is set', ->
      readableEntity = new ReadableEntity()
      assert.equal(JSON.stringify(readableEntity.getContentList()),"[]")
    )
    it('Should get the list of content pushed', ->
      ## test with three contents
      readableEntity = new ReadableEntity()
      assert.typeOf(readableEntity.updateContent,"function","updateContent is not callable")
      readableEntity.updateContent({content:"Test1"})

      contentList = readableEntity.getContentList()
      assert.isArray(contentList, "getContentList() should return an array")
      assert.equal(contentList.length, 1, "The array returned is incorrect")
      assert.typeOf(contentList[0].content, "string","returned the wrong content")
      assert.equal(contentList[0].content, "Test1", "The content of the array returned is incorrect")

      readableEntity.updateContent({content:"Test2"})

      contentList = readableEntity.getContentList()
      assert.isArray(contentList, "getContentList() should return an array")
      assert.equal(contentList.length, 2, "The array returned is incorrect")
      assert.typeOf(contentList[0].content, "string","returned the wrong content")
      assert.equal(contentList[0].content, "Test1", "The content of the array returned is incorrect")
      assert.typeOf(contentList[1].content, "string","returned the wrong content")
      assert.equal(contentList[1].content, "Test2", "The content of the array returned is incorrect")

      readableEntity.updateContent({content:"Test3"})

      contentList = readableEntity.getContentList()
      assert.isArray(contentList, "getContentList() should return an array")
      assert.equal(contentList.length, 3, "The array returned is incorrect")
      assert.typeOf(contentList[0].content, "string","returned the wrong content")
      assert.equal(contentList[0].content, "Test1", "The content of the array returned is incorrect")
      assert.typeOf(contentList[1].content, "string","returned the wrong content")
      assert.equal(contentList[1].content, "Test2", "The content of the array returned is incorrect")
      assert.typeOf(contentList[2].content, "string","returned the wrong content")
      assert.equal(contentList[2].content, "Test3", "The content of the array returned is incorrect")
    )    
  )
#------------------------------------------------------------------------------------------
  describe('#updateContent', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().updateContent,"function")
    )
    ## all other methods are using it into their test so I guess it should be enougth
  )
#------------------------------------------------------------------------------------------
  describe('#getLastContentOfExtension', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().getLastContentOfExtension,"function")
    )

    it('Should return null when there is no content available matching the extension', ->
      assert.equal(new ReadableEntity().getLastContentOfExtension('ff'),null)
    )

    it('Should return the last content available matching the extension', ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'A',extension:'txt'})
      readableEntity.updateContent({content:'B',extension:'txt'})
      content = readableEntity.getLastContentOfExtension('txt')
      assert.typeOf(content,'object', 'the function should return an object')
      assert.equal(content.content, 'B', 'the function returned the wrong content')
    )

    it('Should return null when the extension is null', ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'A',extension:'txt'})
      content = readableEntity.getLastContentOfExtension(null)
      assert.equal(content, null)
    )
  )
#------------------------------------------------------------------------------------------
  describe('#getLastExecutableContent', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().getLastExecutableContent,"function")
    )
    it('Should return the last executable content', ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContent({content:'A',extension:'txt'})
      readableEntity.updateContent({content:'B',extension:'__exec'})
      readableEntity.updateContent({content:'C',extension:'__exec'})
      readableEntity.updateContent({content:'D',extension:'txt'})

      content = readableEntity.getLastExecutableContent()
      assert.typeOf(content,'string', 'the function should return the content pushed')
      assert.equal(content, 'C', 'the function should return the content pushed')      
    )    
  )
#------------------------------------------------------------------------------------------
  describe('ReadableEntity', ->
    it('Should be an instance of ReadableEntity', ->
      assert.equal(new ReadableEntity().ReadableEntity, true)
    )
  )
#------------------------------------------------------------------------------------------
  describe('#updateContentFromFile', ->
    it('Should be a callable function', ->
      assert.typeOf(new ReadableEntity().updateContentFromFile,"function")
    )
    it('Should gather the content from a file', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContentFromFile("#{__dirname}/testFiles/dummyFile.txt", (err,dt) ->
        try
          assert.equal(err, null, "updateContentFromFile throws an error");
          assert.equal(dt.content, "DUMMYCONTENT", "the content of the file read is invalid");
          assert.typeOf(dt.filename,"string")
          assert.typeOf(dt.content,"string")
          assert.equal(dt.extension,"txt")
          cb()
        catch e
          cb(e)
      )
    )
    it('Should return an error when the file cannot be read', (cb) ->
      readableEntity = new ReadableEntity()
      readableEntity.updateContentFromFile("This/file/do/not/exist", (err,dt) ->
        try
          assert.equal(toType(err),"error", "the function returned an invalid error");
          assert.equal(dt,null,"the function should return null")
          cb()
        catch e
          cb(e)
      )
    )

    it('Should call updateContent', (cb) ->
      try
        readableEntity = new ReadableEntity()
        readableEntity.updateContent({content:'A'})
        readableEntity.updateContentFromFile("#{__dirname}/testFiles/dummyFile.txt", (err,dt) ->
          try
            assert.equal(""+(readableEntity.getCurrentContent().content),"DUMMYCONTENT", "the content was not updated");
            cb()
          catch e
            cb(e)
        )
      catch e
        cb(e)
    )
  )
)