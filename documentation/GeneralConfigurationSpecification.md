# Jelly.js General Configuration Specification


## Introduction

The General Configuration file is an important component of the framework. The list of all the configuration files can be found on the main configuration file (see the MainConfigurationSpecification doc).

## Specification

Here is an example of all the features the file should support :

```json
  {
    name:'Client'
    moduleConfigurationFilename:'assets.json'
    plugins: ['concat','output']
    pluginParameters: {
      'output': {
        /* output plugin parameters */
      }
    }
    loadedModules: [
      {name:"menu",params:{}},
      {name:"newsletter",params:{}}
    ]
  }
```
### Entries :

#### name
The name entry is representing the name of the context of the General Configuration File.
If will be used for log files, outputs and others.
If this entry does not exist, the name of the file will be used as shown in the following example :

  - If the filename is 'clientConfig.json', the name will be 'clientConfig'.

#### moduleConfigurationFilename

In each module, the framework will read a file named by the moduleConfigurationFilename entry.
Each module will be processed and this file will be read each time.
If not specified, the default value is 'assets.json'

Pseudo-Algorithm loop :

```
for each module in config.loadedModules
  readFile(config.moduleConfigurationFilename || 'assets.json')
  interpretFile
```

#### plugins

The list of plugin to load for the general configuration (as an Array of String).
Plugins are applied in the order specified by the array.
General Configuration Plugins are processed after Module plugins and File plugins.

(more details on the PluginsSpecification Documentation)

#### pluginParameters

Because some plugins might require additional parameters to work, this entry is here for this purpose.

Example with a plugin processing all templates files to transform any ```<script type="text/coffeescript">...</script>``` into plain javascript :

```json
  [...]

  pluginParameters: {
    'templateCoffeeMiddleware' : {
      'bare':true
    }

  [...]
```
Where 'bare' is the bare parameter (closure) for coffeescript.






