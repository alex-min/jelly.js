module.exports = {
 unload : function (cb) {
  this.getLogger().info("<PLUGIN>:testPlugin2 'unload' fired !")
  cb()
 },

 load : function (cb) {
  this.getLogger().info("<PLUGIN>:testPlugin2 'load' fired !")
  cb()
 },

 oncall: function (sender, params, cb) {
  this.getLogger().info("<PLUGIN>:testPlugin2 'oncall' fired !")  
  cb()
 }
}