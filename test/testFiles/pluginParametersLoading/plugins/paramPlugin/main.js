module.exports = {
 unload : function (cb) {
  this.getLogger().info("<PLUGIN>:pluginParam 'unload' fired !")
  cb()
 },

 load : function (cb) {
  this.getLogger().info("<PLUGIN>:pluginParam 'load' fired !")
  cb()
 },

 oncall: function (sender, params, cb) {
  this.getLogger().info("<PLUGIN>:pluginParam 'oncall' fired !");
  if (typeof(params.pluginParameters) !== 'undefined'
		&& typeof(params.pluginParameters.paramPlugin) !== 'undefined' && params.pluginParameters.paramPlugin.TEST === 1) {
	cb();
  } else {
	cb(new Error("pluginParam must be called with params.pluginParameters.paramPlugin.TEST === 1, params " + JSON.stringify(params) + ""));
  }
 }
}
