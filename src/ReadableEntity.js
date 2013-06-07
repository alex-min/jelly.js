// Generated by CoffeeScript 1.6.2
var Events, ReadableEntity, Tools, async, fs, path, _ReadableEntity;

fs = require('fs');

path = require('path');

async = require('async');

Events = require('./Events');

Tools = require('./Tools');

/**
 * RedeableEntity is an (almost) abstract class to deal with general content
 * The main goal of this class is to provide a way to retreive multiple versions of the same content (which was processed)
 * 
 * @class ReadableEntity
 * @extends Events
*/


ReadableEntity = Tools.implementing(Events, _ReadableEntity = (function() {
  function _ReadableEntity() {}

  return _ReadableEntity;

})(), ReadableEntity = (function() {
  ReadableEntity.prototype._constructor_ = function() {
    if (!this._cs) {
      this._cs = true;
      return this._entityContentList = [];
    }
  };

  function ReadableEntity() {
    this._constructor_();
  }

  ReadableEntity.prototype.ReadableEntity = true;

  /**
   * Get the current state of the content
   *
   * @for ReadableEntity
   * @method getCurrentContent
   * @return {String} Current state of the content
  */


  ReadableEntity.prototype.getCurrentContent = function() {
    return this._entityContentList.slice(-1)[0] || {};
  };

  /**
   * Get the current state of the content as an entity
   * This is the same thing as calling this.getCurrentContent().content
   *
   * @for ReadableEntity
   * @method getCurrentContentEntity
   * @return {String} Current state of the content (only the entity part)
  */


  ReadableEntity.prototype.getCurrentContentEntity = function() {
    return this.getCurrentContent().content;
  };

  /**
   * Erase all the contents
   *
   * @for ReadableEntity
   * @method eraseContent
  */


  ReadableEntity.prototype.eraseContent = function() {
    var _ref;

    if ((_ref = this._entityContentList) == null) {
      this._entityContentList = [];
    }
    return this._entityContentList.length = 0;
  };

  /**
   * Get the first content registred
   * -> Should return an empty object if nothing is set
   *
   * @for ReadableEntity
   * @method getFirstContent
   * @return first content registred
  */


  ReadableEntity.prototype.getFirstContent = function() {
    return this._entityContentList[0] || {};
  };

  /**
   * Get the list of content registred
   *
   * @for ReadableEntity
   * @method getContentList
   * @return list of content registred
  */


  ReadableEntity.prototype.getContentList = function() {
    return this._entityContentList;
  };

  /**
   * Get the last content of a given extension
   * Returns null if no content is found
   *
   * @for ReadableEntity
   * @method getLastContentOfExtension
   * @param {String} extension
   * @return last content of the given extension
  */


  ReadableEntity.prototype.getLastContentOfExtension = function(ext) {
    var content, _i, _ref;

    if (typeof ext === 'undefined' || ext === null) {
      return null;
    }
    _ref = this._entityContentList;
    for (_i = _ref.length - 1; _i >= 0; _i += -1) {
      content = _ref[_i];
      if (content.extension === ext) {
        return content;
      }
    }
    return null;
  };

  /**
   * Get last executableContent
   * Equivalent to this.getLastContentOfExtension('__exec')
   * (__exec is the extension for executable js code)
   *
   * @for ReadableEntity
   * @method getLastExecutableContent
   * @param {String} extension
   * @return last content of the given extension
  */


  ReadableEntity.prototype.getLastExecutableContent = function() {
    var content;

    content = this.getLastContentOfExtension('__exec') || {};
    return content.content || null;
  };

  /**
   * Get the current content and try to eval it to execute it
   * This function can only handle 'json' or 'js' extensions and will return errors for everything else 
   * The content will be pushed as the currentContent.
   * Eval will be called for 'js' content and 'JSON.parse' for 'json' content  
   *
   * @for ReadableEntity
   * @method updateAndExecuteCurrentContent
   * @param {Function} callback to call when the work is done, params : (err : errors, content)
  */


  ReadableEntity.prototype.updateAndExecuteCurrentContent = function(cb) {
    var content, curContent, e, execContent;

    try {
      cb = cb || function() {};
      curContent = this.getCurrentContent();
      if (typeof curContent.content === 'undefined' || curContent.content === null) {
        cb(new Error("There is no content on the stack to execute"), null);
        cb = function() {};
        return;
      }
      if (typeof curContent.extension === 'undefined' || curContent.extension === null) {
        cb(new Error('The last content on the stack do not have any' + ' extension associated, it might not be executable'));
        cb = function() {};
        return;
      }
      if (curContent.extension !== 'json' && curContent.extension !== 'js') {
        cb(new Error("Only 'json' and 'js' content can be executed" + (", the current stack has an extension of " + curContent.extension)), null);
        cb = function() {};
        return;
      }
      execContent = null;
      try {
        switch (curContent.extension) {
          case 'json':
            execContent = JSON.parse(curContent.content);
            break;
          case 'js':
            execContent = eval(curContent.content);
        }
      } catch (_error) {
        e = _error;
        cb(new Error("Unable to parse content " + curContent.content + ", " + e), null);
        cb = function() {};
        return;
      }
      content = {
        extension: '__exec',
        content: execContent
      };
      this.updateContent(content);
      cb(null, content);
      return cb = function() {};
    } catch (_error) {
      e = _error;
      cb(e, null);
      return cb = function() {};
    }
  };

  /**
   * Update content from a file and execute it after
   * Equivalent of calling updateContentFromFile and updateAndExecuteCurrentContent methods.
   * @for ReadableEntity
   * @method readUpdateAndExecute
   * @param {String} fileLocation : the location of the file to read
   * @param {String} encoding : Encoding of the file (default:utf8)  
   * @param {Function} callback to call when the work is done, params : (err : errors)
  */


  ReadableEntity.prototype.readUpdateAndExecute = function(fileLocation, encoding, cb) {
    var self;

    cb = cb || function() {};
    self = this;
    return async.series([
      function(cb) {
        var e;

        try {
          return self.updateContentFromFile(fileLocation, 'utf8', function(err, res) {
            return cb(err, null);
          });
        } catch (_error) {
          e = _error;
          return cb(e);
        }
      }, function(cb) {
        return self.updateAndExecuteCurrentContent(function(err) {
          return cb(err);
        });
      }
    ], function(err) {
      if (err) {
        return cb(new Error(err));
      } else {
        return cb(null);
      }
    });
  };

  /**
   * Update the content stored
   *
   * @for ReadableEntity
   * @method updateContent
  */


  ReadableEntity.prototype.updateContent = function(content) {
    return this._entityContentList.push(content);
  };

  /**
   * Update the content from a given file
   *
   * @for ReadableEntity
   * @method updateContent
  */


  ReadableEntity.prototype.updateContentFromFile = function(filename, encoding, cb) {
    var self;

    if (encoding == null) {
      encoding = "utf8";
    }
    self = this;
    cb = cb || encoding;
    if (typeof cb !== 'function') {
      cb = function() {};
    }
    if (typeof encoding !== 'string') {
      encoding = 'utf8';
    }
    return fs.readFile(filename, function(err, content) {
      var extension;

      try {
        if (err) {
          cb(err, null);
          cb = function() {};
          return;
        }
        extension = path.extname(filename).replace('.', '');
        content = {
          filename: filename,
          content: content + '',
          extension: extension
        };
        self.updateContent(content);
        cb(err, content);
        return cb = function() {};
      } catch (_error) {
        err = _error;
        return cb(err, null);
      }
    });
  };

  return ReadableEntity;

})());

module.exports = ReadableEntity;
