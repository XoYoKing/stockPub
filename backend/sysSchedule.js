//系统定时任务
//日志压缩打包，应用重启，日志报错扫描等非业务定时任务

var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/sysSchedule_'));
global.logger = log; // 设置全局

var email = require('./utility/emailTool');
var cronJob = require('cron').CronJob;




process.on('uncaughtException', function(err) {
    log.error('system schedule process Caught exception: ' +
        err.stack);

    email.sendMail('Caught exception: ' + err.stack,
    			'system schedule process failed');
});
