

var path = require('path');
var log = require('../../log.js');
log.SetLogFileName('test');
var child_process = require('child_process');


log.info('zip everyday log', log.getFileNameAndLineNum(__filename));
child_process.execFile('../../sh_script/zipLog.sh', null, {}, function(err, stdout, stderr){
    if(err!=null){
        log.error(err, log.getFileNameAndLineNum(__filename));
    }else{
        log.info("zipLog finish", log.getFileNameAndLineNum(__filename));
    }
});
