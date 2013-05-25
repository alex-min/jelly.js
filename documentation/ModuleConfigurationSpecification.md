# Jelly.js Module Configuration Specification

## General Guidelines

Each module can be found under a sub-directory on the ```app``` folder.
The name of the module configuration file is specified from the general configuration file (see the GeneralConfigurationSpecification documentation).

Example :

```
config/
app/
 menu/
  assets.json
 newsletter/
  assets.json
 auth/
  assets.json
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

There is a lot of option with the module configuration file, lets describe them all !

#### fileList

An array of Objects describing what file is included within a particular module.

**name** : The name of the file to read, each file should be prefixed by its module name under the directory.

Example : If the file is ```file1.js```, the module name ```menu``` and ```pathList['js']``` value is ```/static/js```,
The framework will search for ```/static/js/menu-file1.js``` under the menu directory.

The general algorithm for searching file is :

```config.pathList[fileExtension] + '/' + moduleName + '-' + filename```

**params** : Additional parameters can be specified on a given file, here is the current list of them :

  - encoding : Which encoding has the file, the default is 'utf8', other possible values are describe in the node.js documentation (fs.readFile)
  - includeOnBuild : If you need to add a file only in devlopment mode, you can add the parameter ```includeOnBuild:['dev']``` to exclude the file on the production mode.

#### pathList

Each filetype can have its own subdirectory on each module.
For example, if ```coffee:'/static/js'``` is specified, each coffee file will be read from the ```/static/js``` subdirectory.

The general algorithm for searching file is :

```config.pathList[fileExtension] + '/' + moduleName + '-' + filename```

If there is no pathlist specified for a given extension, the extension of the file will be used instead.

**Example** : A ```coffee``` file will be searched on the ```/coffee``` subdirectory.

#### plugins

The plugin entry is containing a list of plugins to load. Each plugin is processed independently (but in the exact order).

Plugin parameters can be found on the ```pluginParameters``` entry.

(see the PluginSpecification documentation for more information on plugins)

#### pluginParameters

Because some plugins might require additional parameters to work, this entry is here for this purpose.

Example with a plugin processing all templates files to transform any ```<script type="text/coffeescript">...</script>``` into plain javascript :

```json
  pluginParameters: {
    'templateCoffeeMiddleware' : {
      'bare':true
    }
```
Where 'bare' is the bare parameter (closure) for coffeescript.

(more details on the PluginsSpecification Documentation)

#### modulePlugins

Because the ```plugins``` entry is only dealing with plugins related to files, this entry can apply plugin on a module basis.

Module plugins will be processed after file plugins.

(see the PluginSpecification documentation for more information on plugins)

#### modulePluginParameters

This entry is working exactly like the ```pluginParameters``` entry but for module plugins.

(see the PluginSpecification documentation for more information on plugins)
