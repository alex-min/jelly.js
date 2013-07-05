Mocha = require('mocha')
fs = require('fs')
async = require('async')

mocha = new Mocha()
rootDir = __dirname

async.series([
  # main test directory
  (cb) ->
      dir = "#{rootDir}/test"
      fs.readdir(dir, (err, files) ->
        if err?
          cb(err)
          return
        for file in files
          if /\.js$/.test(file)
            mocha.addFile("#{dir}/#{file}")
        cb()
      )
  # plugins
  (cb) ->
    dir = "#{rootDir}/src/plugins"    
    fs.readdir(dir, (err, files) ->
      if err
        cb(err)
        return
      async.map(files, (folder, cb) ->
        curDir = "#{dir}/#{folder}/test"
        fs.readdir(curDir, (err, files) ->
          if err
            cb()
            return
          for file in files
            if /\.js$/.test(file)
              mocha.addFile("#{curDir}/#{file}")      
          cb()    
          return
        )
      , (err) ->
        cb(err)
      )
    )
    ;  
  (cb) ->
    runner = mocha.run( (e) ->
      process.exit(e)
    ) 
], (err) ->
  if err
    process.exit(1)
)

