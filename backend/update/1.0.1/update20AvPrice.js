var path = require('path');
var log = require('../../log.js');
var moment = require('moment');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('update20AvPrice');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');

stockOperation.getDate(function(flag, result){
    if(flag){
        result.forEach(function(e){
            if(e.date>'2015-11-01'){
                caculate.caculateAvPrice(20, e.date);
            }
        });
    }else{

    }
});
