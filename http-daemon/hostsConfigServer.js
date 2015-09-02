var config = require('./config.json')
var express = require('express');
var bodyParser = require('body-parser');
var Busboy = require('busboy');
var fs = require('fs');
var inspect = require('util').inspect;
var path = require('path');

var hostConfigServer = express();

hostConfigServer.use(express.static('public'));
hostConfigServer.use(bodyParser.urlencoded({ extended: true }));
hostConfigServer.use(bodyParser.json({ type: 'application/json' }));

var hosts = {
    'case1_db': null,
    'case1_app': null
};

var writeHostsIni = function(){
    var res = "";
    for (var group in hosts) {
        if (hosts.hasOwnProperty(group)) {
            res+='['+group+']\r\n'+hosts[group]+'\r\n\r\n';
        }
    }
    fs.writeFile("hosts-config/hosts-config.ini", res);
};

hostConfigServer.post('/', function(req, res){
    var bb = new Busboy({headers: req.headers});
    bb.on('file', function(fieldname, file) {
        var saveTo = path.join("hosts-config", path.basename('case_1_ssh_key.pem'));
        file.pipe(fs.createWriteStream(saveTo));
    });
    bb.on('field', function(fieldname, val) {
        console.log(fieldname +':'+val);
        hosts[fieldname]=val;
    });
    bb.on('finish', function() {
        writeHostsIni();
        res.sendStatus(200);
    });
    return req.pipe(bb);
});

hostConfigServer.listen(80);

