var path = require('path');
var log = require('../../log.js');
log.SetLogFileName('./'+__filename+'.log');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');

caculate.caculateDurationYield();
