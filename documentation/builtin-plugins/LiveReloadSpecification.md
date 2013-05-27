# Jelly.js LiveReload Specification

## General Information

**Name** : 'liveReload'

The main goal of the livereload plugin is to provide a simple way to update content with the framework without restarting everything.

This plugin can be used on any type of configuration file (general,file and module).

## Parameters

### File

```json
    pluginParameters : {
        'liveReload':{
          excludeFile:'example.js'
        }
    }
```

**excludeFile**: Because by default, the livereload plugin is applying to all files, the **excludeFile** parameter can specify a file to exclude from the livereload plugin.

### Module

```json
  modulePluginParameters : {
      'liveReload':{
        forceDisable:true
      }
  }
```
**forceDisable**: Because by default, the livereload plugin is applying to all modules, the **forceDisable** parameter can specify that the module cannot be used with the liveReload plugin.

### General configuration file

```json
  pluginParameters : {
      'liveReload':{
        exludeModule:'moduleToExclude'
      }
  }
```
**excludeModule**: Because by default, the livereload plugin is applying to all modules, the **excludeModule** parameter can specify a file to exclude from the livereload plugin.
