var path = require('path');
var log = require('../../log.js');
var moment = require('moment');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('update5AvPrice');
global.logger = log; // 设置全局

var caculate = require('../../utility/caculate');
var async = require('async');
var conn = require('../../utility.js');

stockOperation.getAllStockCode(function(flag, result){
    if(flag){
        result.forEach(function(e){
            var sql = 'select *from stock_amount_info where stock_code = ? order by date desc';
            conn.executeSql(sql, [e.stock_code], function(flag, result){
                if(flag){
                    var total = 0;
                    var avPrice = 0;
                    for (var i = 0; i + 4 < result.length; i++) {
                        if(i === 0){
                            for (var j = 0; j < 5; j++) {
                                total += result[i+j].price;
                            }
                            avPrice = total/5;
                            stockOperation.update5AvPrice(e.stock_code, avPrice, result[i].date, function(flag, result){
                                if(flag){

                                }else{
                                    logger.error(result, logger.getFileNameAndLineNum(__filename));
                                }
                            });
                        }else{
                            total-=result[i-1].price;
                            total+=result[i+4].price;
                            avPrice = total/5;
                            stockOperation.update5AvPrice(e.stock_code, avPrice, result[i].date, function(flag, result){
                                if(flag){

                                }else{
                                    logger.error(result, logger.getFileNameAndLineNum(__filename));
                                }
                            });
                        }
                    }
                }else{
                    logger.error(result, logger.getFileNameAndLineNum(__filename));
                }
            });
        });

    }else{
        logger.error(result, logger.getFileNameAndLineNum(__filename));
    }
});
