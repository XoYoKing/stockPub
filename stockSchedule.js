var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockSchedule_'));
global.logger = log; // 设置全局

var schedule = require("node-schedule");
var crawl = require('./stockCrawl.js');

log.info("run schedule", log.getFileNameAndLineNum(__filename));

//实时行情
schedule.scheduleJob('*/3 9-14 * * 1-5', function(){
    log.info("stock crawl Now start", log.getFileNameAndLineNum(__filename));
    crawl.startCrawlStockNow();
});

//日终行情
schedule.scheduleJob('5 15 * * 1-5', function(){
    log.info("stock crawl day start", log.getFileNameAndLineNum(__filename));
    crawl.startGetAllStockInfo();
});

process.on('uncaughtException', function(err) {
    log.error('schedule process Caught exception: ' +
        err.stack);
});
