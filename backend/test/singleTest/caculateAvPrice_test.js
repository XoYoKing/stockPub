var path = require('path');
var log = require('../../log.js');
log.SetLogFileName('test');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');

caculate.caculateAvPrice(5);
caculate.caculateAvPrice(10);
caculate.caculateAvPrice(20);
