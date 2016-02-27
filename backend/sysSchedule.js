//系统定时任务
//日志压缩打包，应用重启，日志报错扫描等非业务定时任务

var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/sysSchedule_'));
global.logger = log; // 设置全局

var email = require('./utility/emailTool');
var cronJob = require('cron').CronJob;
var child_process = require('child_process');

log.info("run sys cron job", log.getFileNameAndLineNum(__filename));

//当日日志打包
new cronJob('00 59 23 * * *', function(){
    log.info('zip everyday log', log.getFileNameAndLineNum(__filename));
    child_process.execFile(__dirname + '/sh_script/zipLog.sh', null, {}, function(err, stdout, stderr){
        if(err!=null){
            log.error(err, log.getFileNameAndLineNum(__filename));
        }else{
            log.info("zipLog finish", log.getFileNameAndLineNum(__filename));
        }
    });
}, null, true);


//重启所有应用
new cronJob('00 00 4 * * *', function(){
    log.info('restart all app', log.getFileNameAndLineNum(__filename));
    child_process.execFile(__dirname + '/sh_script/startAll.sh', null, {}, function(err, stdout, stderr){
        if(err!=null){
            log.error(err, log.getFileNameAndLineNum(__filename));
        }else{
            log.info("restart all finish", log.getFileNameAndLineNum(__filename));
        }
    });
}, null, true);

//错误日志扫描发送邮件

//统计upv，pv




process.on('uncaughtException', function(err) {
    log.error('system schedule process Caught exception: ' +
        err.stack);

    email.sendMail('Caught exception: ' + err.stack,
    			'system schedule process failed');
});
