srcDirectory = __dirname + '/src/';

exportList = [
  'Events'
  'File'
  'GeneralConfiguration'
  'Jelly'
  'Logger'
  'Module'
  'PluginDirectory'
  'PluginHandler'
  'PluginInterface'
  'PluginWrapper'
  'ReadableEntity'
  'SharedObject'
  'SharedObjectManager'
  'Tools'
  'TreeElement'
]

exportObject = {}
for curExport in exportList
  exportObject[curExport] = require("#{srcDirectory}/#{curExport}")

module.exports = exportObject