var config = require('./config.json')
var express = require('express');

console.log(JSON.stringify(config));

var repository = express();
repository.use(express.static(config.dir)).listen(config.port);