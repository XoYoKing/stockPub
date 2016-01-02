require('mocha');

var http = require('http');

var hostname = '112.74.102.178';

exports.runTest = function(jsonObject, childpath, callback){
    var options = {
        port: 18000,
        hostname: hostname,
        method: 'POST',
        path: childpath,
        timeout: 3000,
        headers: {
            'Content-Type': 'application/json; encoding=utf-8',
            'Accept': 'application/json',
            'Content-Length': JSON.stringify(jsonObject).length
        }
    };

    var body = '';

    var req = http.request(options, function(res) {
        console.log("Got response: " + res.statusCode);
        if(res.statusCode!=200){
            callback(res.statusCode, 'error code: '+res.statusCode);
        }
        res.on('data', function(d) {
            body += d;
        }).on('end', function() {
            console.log(res.headers);
            console.log(body);
            callback(null, JSON.parse(body));
        });

    }).on('error', function(e) {
        console.log("Got error: " + e.message);
        callback(e, e.message);
    });

    req.setTimeout(3000, function(){
        callback('timeout', 'timeout');
    });

    req.write(JSON.stringify(jsonObject));
    req.end();
};
