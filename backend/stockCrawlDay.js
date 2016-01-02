var log4js = require('log4js');
var path = require('path');

log4js.configure({
        appenders: [{
            type: 'console'
        }, {
            type: 'dateFile',
            absolute: true,
            filename: path.join(process.env.HOME, 'stocklogs/stockDay_'),
            maxLogSize: 1024 * 1024,
            backups: 4,
            pattern: "yyyy-MM-dd.log",
            alwaysIncludePattern: true,
            category: 'normal'
        }],
        replaceConsole: true
    });

var logger = log4js.getLogger('normal');
logger.setLevel('DEBUG'); //配置日志打印级别，低于此级别的不打印
global.logger = logger;



var stockCrawl = require('./stockCrawl');

stockCrawl.startGetAllStockInfo();

process.on('uncaughtException', function(err) {
    logger.error(err);
});
