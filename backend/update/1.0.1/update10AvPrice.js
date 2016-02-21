var path = require('path');
var log = require('../../log.js');
var moment = require('moment');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('update10AvPrice');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');

stockOperation.getDate(function(flag, result){
    if(flag){
        result.forEach(function(e){
            if(e.date > '2016-01-01'){
                caculate.caculateAvPrice(10, e.date);
            }
        });
    }else{

    }
});
