var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockSchedule_'));
global.logger = log; // 设置全局

var schedule = require("node-schedule");
var crawl = require('./stockCrawl.js');
var email = require('./utility/emailTool');


log.info("run schedule", log.getFileNameAndLineNum(__filename));

//实时行情-上午
schedule.scheduleJob('*/1 9-11 * * 1-5', function(){
    log.info("stock crawl Now start", log.getFileNameAndLineNum(__filename));
    crawl.startCrawlStockNow();
});

//实时行情-下午
schedule.scheduleJob('*/1 13-14 * * 1-5', function(){
    log.info("stock crawl Now start", log.getFileNameAndLineNum(__filename));
    crawl.startCrawlStockNow();
});

//日终行情
schedule.scheduleJob('5 15 * * 1-5', function(){
    log.info("stock crawl day start", log.getFileNameAndLineNum(__filename));
    crawl.startGetAllStockInfo();
});

//开市前删除now表中数据
schedule.scheduleJob('15 9 * * 1-5', function(){
    log.info("delete stock now data", log.getFileNameAndLineNum(__filename));
    crawl.emptyStockNowInfo();
});

process.on('uncaughtException', function(err) {
    log.error('schedule process Caught exception: ' +
        err.stack);

    email.sendMail('Caught exception: ' + err.stack,
    			'stockSchedule process failed');
});
