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
            console.log(e.date);
        });
    }else{

    }
});

// caculate.caculateAvPrice(5, moment().format('YYYY-MM-DD'));
// caculate.caculateAvPrice(10, moment().format('YYYY-MM-DD'));
// caculate.caculateAvPrice(20, moment().format('YYYY-MM-DD'));
