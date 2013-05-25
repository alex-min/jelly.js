# Jelly.js Plugins Specification

## General Guidelines

Plugins are one on the only way to customize the framework and to modify files on the fly.

All plugins have to be under the plugins directory of the project folder.
All plugins in this folder will be loaded when starting the framework.

Example :

```
  conf/
  app/
  plugins/
    output/
      main.js
    wrap/
      main.js
    coffee/
      main.js
```


## Plugin prototype

Each plugin have to provide a ```main.js``` file with some pre-defined functions on export :

Because each function can be coded in an asynchronous way, the callback should be fired to notify that the function finished its job. 

### export.onload (callback) [optional]

This function is triggered when loading the plugin

### export.onunload (callback) [optional]

This function is triggered when unloading the module.
It should be possible to load the module again (this will trigger the onload method again).

### export.oncall (&lt;Unit&gt;, callback) [mandatory]

The &lt;Unit&gt; type is changing according to the call context of the plugin.
Because the same plugin can be used on a Module, a File and a General Configuration, the &lt;Unit&gt; type can represent multiple objects.
The call ```Unit.getType()``` should always be valid and return the type of configuration :
  - __'Module'__ for a plugin which will apply to an entire module (a Module object is passed to the plugin)
  - __'File'__ for a plugin which will apply to only a file.
  - __'General'__ for a plugin which will apply to all Modules.

The context of the function will be bound to a ```PluginHandler``` object and all methods related to this class (look on the ```PluginHandler``` file) should remain accessible (such as ```this.getLogger().info()``` to log information).
