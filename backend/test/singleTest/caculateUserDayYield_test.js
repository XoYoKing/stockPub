
var caculate = require('../../utility/caculate');
var log = require('../../log.js');

log.SetLogFileName('test');
global.logger = log; // 设置全局

caculate.caculateUserDayYield();
