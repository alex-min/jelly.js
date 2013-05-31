require('longjohn')
 = require('./src/ReadableEntity');

r = new ReadableEntity();

r.updateContentFromFile('./package.json');

Logger = require('./src/Logger');
log = new Logger();

Jelly = require('./src/Jelly');

jelly = new Jelly();
jelly.getLogger().info('pelos');