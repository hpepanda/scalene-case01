var config = require('./config.json')

console.log(JSON.stringify(config));

var connect = require('connect');
var serveStatic = require('serve-static');
connect().use(serveStatic(config.dir)).listen(config.port);
