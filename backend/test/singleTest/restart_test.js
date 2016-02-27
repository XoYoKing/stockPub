

var path = require('path');
var log = require('../../log.js');
log.SetLogFileName('test');
var child_process = require('child_process');


log.info('restart all app', log.getFileNameAndLineNum(__filename));
child_process.execFile('../../sh_script/startAll.sh', null, {}, function(err, stdout, stderr){
    if(err!=null){
        log.error(err, log.getFileNameAndLineNum(__filename));
    }else{
        log.info("restart all finish", log.getFileNameAndLineNum(__filename));
    }
});
