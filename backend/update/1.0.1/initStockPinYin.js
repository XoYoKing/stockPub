
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
            var alphaStr = '';
            alpha.forEach(function(e){
                alphaStr+=e[0];
            });
            alphaStr = alphaStr.replace('*', '');
            alphaStr = alphaStr.replace(' ', '');
            alphaStr = alphaStr.toLowerCase();
            alphaStr+=e.stock_name;
            alphaStr+=e.stock_code;
            console.log(e.stock_name+":"+alphaStr);

            stockOperation.updateStockAlpha(e.stock_code, alphaStr, function(flag, result){
                if(flag){

                }else{
                    log.error(result, log.getFileNameAndLineNum(__filename));
                }
            });

        });
    }else{
        log.error(result, log.getFileNameAndLineNum(__filename));
    }
});
