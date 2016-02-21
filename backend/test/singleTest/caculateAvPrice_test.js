var path = require('path');
var log = require('../../log.js');
var moment = require('moment');
log.SetLogFileName('test');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');


caculate.caculateAvPrice(5, moment().format('YYYY-MM-DD'));
caculate.caculateAvPrice(10, moment().format('YYYY-MM-DD'));
caculate.caculateAvPrice(20, moment().format('YYYY-MM-DD'));
