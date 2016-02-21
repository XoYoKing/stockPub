var path = require('path');
var log = require('../../log.js');
var moment = require('moment');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('updateAvPrice');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');

stockOperation.getDate(function(flag, result){
    if(flag){
        result.forEach(function(e){
            caculate.caculateAvPrice(5, e.date);
            caculate.caculateAvPrice(10, e.date);
            caculate.caculateAvPrice(20, e.date);
        });
    }else{

    }
});
