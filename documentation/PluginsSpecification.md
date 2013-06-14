# Jelly.js Plugins Specification

## General Guidelines

Plugins are one on the only way to customize the framework and to modify files on the fly.

All plugins have to be under the plugins directory of the project folder.
All plugins in this folder will be loaded when starting the framework.
Built-in plugins can be found under the /plugins subfolder on the jelly.js root folder.

**Notice**:The default directory for configuration files related to plugins is ```conf/plugins```

Example :

```
  conf/
    plugins/
      route.json
  app/
  plugins/
    output/
      config.json
      main.js
    wrap/
      config.json
      main.js
    coffee/
      config.json
      main.js
```


## Plugin prototype

Each plugin have to provide a javascript file with some pre-defined functions on export.
This file should be named 'main.js' by default but can be defined under the 'config.json' configuration file.

Because each function can be coded in an asynchronous way, the callback provided in each method should be fired to notify that the function has finished its job. 

### export.onload (callback) [optional]

This function is triggered when loading the plugin

### export.onunload (callback) [optional]

This function is triggered when unloading the plugin.
It should be possible to load the plugin again (this will trigger the onload method again).

### export.oncall (&lt;Object&gt;, callback) [mandatory]

The &lt;Object&gt; type is changing according to the call context of the plugin.
Because the same plugin can be used on a Module, a File and a General Configuration, the &lt;Object&gt; type can represent multiple objects.
In order to guess the type of the object, the inheritance scheme is providing 

The context of the function (this) will be bound to a ```PluginHandler``` object and all methods related to this class (look on the ```PluginHandler``` file) should remain accessible (such as ```this.getLogger().info()``` to log information).
