var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockSchedule_'));
global.logger = log; // 设置全局

var crawl = require('./stockCrawl.js');
var email = require('./utility/emailTool');
var caculate = require('./utility/caculate');

var cronJob = require('cron').CronJob;
var moment = require('moment');

var redis = require("redis");
var redisClient = redis.createClient({auth_pass:'here_dev'});
redisClient.on("error", function (err) {
	log.error(err, log.getFileNameAndLineNum(__filename));
});
var stockOperation = require('./databaseOperation/stockOperation');
var config = require('./config');

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

//收盘计算用户总收益率
new cronJob('00 10 15 * * 1-5', function(){
    log.info('caculate yield for all user', log.getFileNameAndLineNum(__filename));
    caculate.caculateAllUserYield();
}, null, true);

//计算最近一周，最近一个月，最近一年的收益
new cronJob('00 12 15 * * 1-5', function(){
    log.info('caculate yield for one week, one month, one year', log.getFileNameAndLineNum(__filename));
    caculate.caculateDurationYield();
}, null, true);



//收盘后播报
new cronJob('00 1 15 * * 1-5', function(){
    log.info('push market close msg to users', log.getFileNameAndLineNum(__filename));
    crawl.pushMarketCloseMsg();
}, null, true);


//5日平均价
new cronJob('00 10 15 * * 1-5', function(){
    log.info('5 av price caculate', log.getFileNameAndLineNum(__filename));
    caculate.caculateAvPrice(5, moment().format('YYYY-MM-DD'));
    caculate.caculateMarketAvPrice(5, moment().format('YYYYMMDD'));
}, null, true);

//10日平均价
new cronJob('00 15 15 * * 1-5', function(){
    log.info('10 av price caculate', log.getFileNameAndLineNum(__filename));
    caculate.caculateAvPrice(10, moment().format('YYYY-MM-DD'));
    caculate.caculateMarketAvPrice(10, moment().format('YYYYMMDD'));

}, null, true);

//20日平均价
new cronJob('00 20 15 * * 1-5', function(){
    log.info('20 av price caculate', log.getFileNameAndLineNum(__filename));
    caculate.caculateAvPrice(20, moment().format('YYYY-MM-DD'));
    caculate.caculateMarketAvPrice(20, moment().format('YYYYMMDD'));
}, null, true);


// //对最近一周，一月，一年收益进行排名
// new cronJob('00 59 23 * * 1-5', function(){
//     log.info('caculate user rank for one week, one month, one year', log.getFileNameAndLineNum(__filename));
//     caculate.caculateUserRank();
// }, null, true);


//每晚股票名字取市场最新
new cronJob('00 00 23 * * *', function(){
    log.info('update stock name everyday', log.getFileNameAndLineNum(__filename));
    crawl.updateStockName();
}, null, true);

process.on('uncaughtException', function(err) {
    log.error('schedule process Caught exception: ' +
        err.stack);

    email.sendMail('Caught exception: ' + err.stack,
    			'stockSchedule process failed');
});
