var logger = global.logger;
var userOperation = require('../databaseOperation/userOperation');
var stockOperation = require('../databaseOperation/stockOperation');
var moment = require('moment');

exports.caculateAllUserYield = function(){
    userOperation.updateAllUserTotalYield(function(flag, result){
        if(flag){
            if(logger == null){
                console.log('success updateAllUserTotalYield');
            }else{
                logger.info('success updateAllUserTotalYield', logger.getFileNameAndLineNum(__filename));
            }
        }else{
            if(logger == null){
                console.log(result);
            }else{
                logger.error(result, logger.getFileNameAndLineNum(__filename));
            }
        }
    });
}

function caculateDurationYieldForSingle(element, durationDay){
    var now_timestamp = Date.now();
    var look_timestamp = element.look_timestamp;
    var durationTimestamp = durationDay*24*3600*1000;
    var stockLookYield = {};
    stockLookYield.look_id = element.look_id;
    stockLookYield.look_duration = durationDay;
    if(now_timestamp - look_timestamp<durationTimestamp){
        //看多时间到现在没有超过durationDay,取总的收益率
        stockLookYield.look_yield = element.stock_yield;
        stockOperation.insertStockLookYield(stockLookYield, function(flag, result){
            if(!flag){
                logger.error(result, logger.getFileNameAndLineNum(__filename));
            }
        });
    }else{
        var price_timestamp = now_timestamp - durationTimestamp;//durationDay之前的时间戳
        var price_date = moment(price_timestamp).format('yyyy-mm-dd');
        console.log(element.stock_code +' price_date ' + price_date);
        stockOperation.getStockDayInfoByDate(element.stock_code, price_date, function(flag, result){
            if(flag){
                if(result.length>0){
                    var stockDayInfo = result[0];
                    stockLookYield.look_yield = 100*(element.look_cur_price - stockDayInfo.price)/element.look_stock_price;
                    stockOperation.insertStockLookYield(stockLookYield, function(flag, result){
                        if(!flag){
                            logger.error(result, logger.getFileNameAndLineNum(__filename));
                        }
                    });
                }else{
                    logger.warn(element.stock_code+' not has record less '+price_date, logger.getFileNameAndLineNum(__filename));
                }
            }else{
                logger.error(result, logger.getFileNameAndLineNum(__filename));
            }
        });
    }
}


exports.caculateDurationYield = function(){
    stockOperation.clearStockLookYield(function(flag, result){
        if(flag){
            stockOperation.getStockLookInfoByStatus(1, function(flag, result){
                if(flag){
                    result.forEach(function(element){
                        caculateDurationYieldForSingle(element, 7);
                        caculateDurationYieldForSingle(element, 30);
                        caculateDurationYieldForSingle(element, 120);
                        caculateDurationYieldForSingle(element, 360);
                    });
                }else{
                    logger.error(result, logger.getFileNameAndLineNum(__filename));
                }
            });
        }else{
            logger.error(result, logger.getFileNameAndLineNum(__filename));
        }
    });
}
