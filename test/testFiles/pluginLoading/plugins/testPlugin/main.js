module.exports = {
 unload : function (cb) {
  this.getLogger().info("<PLUGIN>:testPlugin 'unload' fired !")
  cb()
 },

 load : function (cb) {
  this.getLogger().info("<PLUGIN>:testPlugin 'load' fired !")
  cb()
 }
}
