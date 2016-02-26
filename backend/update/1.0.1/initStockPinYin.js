
var path = require('path');
var log = require('../../log.js');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('initStockPinYin');

var pinyin = require("pinyin");

stockOperation.getAllStockInfo(function(flag, result){
    if(flag){
        result.forEach(function(e){
            var alpha = pinyin(e.stock_name, {
                style: pinyin.STYLE_FIRST_LETTER
            });
            console.log(alpha);
        });
    }else{
        log.error(result, log.getFileNameAndLineNum(__filename));
    }
});
