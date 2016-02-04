var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockSchedule_'));
global.logger = log; // 设置全局

var crawl = require('./stockCrawl.js');
var email = require('./utility/emailTool');
var caculate = require('./utility/caculate');

var cronJob = require('cron').CronJob;


log.info("run CronJob", log.getFileNameAndLineNum(__filename));

//实时行情-上午-每20秒
new cronJob('*/20 * 9-11 * * 1-5', function() {
    log.info("stock crawl Now start", log.getFileNameAndLineNum(__filename));
    crawl.startCrawlStockNow();
    crawl.startCrawlMarket();
}, null, true);



//实时行情-下午-每20秒
new cronJob('*/20 * 13-14 * * 1-5', function(){
    log.info("stock crawl Now start", log.getFileNameAndLineNum(__filename));
    crawl.startCrawlStockNow();
    crawl.startCrawlMarket();
}, null, true);
//
//日终行情
new cronJob('00 5 15 * * 1-5', function(){
    log.info("stock crawl day start", log.getFileNameAndLineNum(__filename));
    crawl.startGetAllStockInfo();
    crawl.startCrawlMarketDay();
}, null, true);

//
//开市前删除now表中数据
new cronJob('00 25 9 * * 1-5', function(){
    log.info("delete stock now data", log.getFileNameAndLineNum(__filename));
    crawl.emptyStockNowInfo();
    crawl.emptyMarketIndexNowInfo();
}, null, true);
//

//日终计算用户总收益率
new cronJob('00 50 23 * * *', function(){
    log.info('caculate yield for all user', log.getFileNameAndLineNum(__filename));
    caculate.caculateAllUserYield();
}, null, true);

//计算最近一周，最近一个月，最近一年的收益
new cronJob('00 14 11 * * *', function(){
    log.info('caculate yield for one week, one month, one year', log.getFileNameAndLineNum(__filename));
    caculate.caculateDurationYield();
}, null, true);


process.on('uncaughtException', function(err) {
    log.error('schedule process Caught exception: ' +
        err.stack);

    email.sendMail('Caught exception: ' + err.stack,
    			'stockSchedule process failed');
});
