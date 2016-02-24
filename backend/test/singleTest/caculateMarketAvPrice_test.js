var path = require('path');
var log = require('../../log.js');
var moment = require('moment');
log.SetLogFileName('test');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');


console.log(moment().format('YYYY-MM-DD'));

caculate.caculateMarketAvPrice(5, moment().format('YYYY-MM-DD'));
caculate.caculateMarketAvPrice(10, moment().format('YYYY-MM-DD'));
caculate.caculateMarketAvPrice(20, moment().format('YYYY-MM-DD'));
