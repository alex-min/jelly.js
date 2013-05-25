# Jelly.js Module Configuration Specification

## General Guidelines

Each module can be found under a sub-directory on the ```app``` folder.

Example :

```
config/
app/
 menu/
 newsletter/
 auth/
 [...] 
```

## Configuration specifications

Here is an example of all the features the file should support :

```json
  {
    fileList:[
      {name:'file1.js',params:{}},
      {name:'file2.js',params:{}},
      {name:'file3.js',params:
        {
          'encoding':'utf8',
          'includeOnBuild':['dev']
        }
      }
    ],
    pathList:[
      coffee:'/static/js',
      js:'/static/js',
      css:'/static/css',
      tpl:'/views/'
      img:'/img/'
    ],

    plugins : [
      'coffee',
      'scss',
      'wrap',
      'tpl',
      'output'
    ],

    pluginParameters : {
      coffee:  {
        bare:true
      }
      wrap: {
        'js': {
          'begin':'/* --BEGIN FILE-- */',
          'end':'/* -- END FILE -- */'
        }
      }
    },

    modulePlugins: ['output'],

    modulePluginParameters : {
      'output':{}
    }
  }
```
### Entries :

There is a lot of option with the module configuration file, lets describe them !

#### fileList

An array of Objects describing what file is included within a particular module.

**name** : The name of the file to read, each file should be prefixed by its module name under the directory.

Example : If the file is ```file1.js```, the module name ```menu``` and ```pathList['js']``` value is ```/static/js```,
The framework will search for ```/static/js/menu-file1.js``` under the menu directory.

The general algorithm for searching file is :

```config.pathList[fileExtension] + '/' + moduleName + '-' + filename```