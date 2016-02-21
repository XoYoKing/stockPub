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

    if(element.look_status == 2){
        //如果取消，需要判断取消的时间是否在durationDay里面
        if(now_timestamp - durationTimestamp > element.look_finish_timestamp){
            //取消的时间比duration还早
            return;
        }
    }


    var stockLookYield = {};
    stockLookYield.look_id = element.look_id;
    stockLookYield.user_id = element.user_id;
    stockLookYield.look_duration = durationDay;
    stockLookYield.look_date = moment(look_timestamp).format('YYYY-MM-DD');
    stockLookYield.look_cur_price = element.look_cur_price;
    stockLookYield.look_cur_price_date = moment(element.look_cur_price_timestamp).format('YYYY-MM-DD');

    if(now_timestamp - look_timestamp<durationTimestamp){
        //看多时间到现在没有超过durationDay,取总的收益率
        stockLookYield.look_yield = element.stock_yield;
        stockLookYield.look_duration_price = element.look_stock_price;
        stockLookYield.look_duration_price_date = moment(element.look_timestamp).format('YYYY-MM-DD');

        stockOperation.insertStockLookYield(stockLookYield, function(flag, result){
            if(!flag){
                logger.error(result, logger.getFileNameAndLineNum(__filename));
            }
        });
    }else{
        var price_timestamp = now_timestamp - durationTimestamp;//durationDay之前的时间戳
        var price_date = moment(price_timestamp).format('YYYY-MM-DD');
        console.log(element.stock_code +' price_date ' + price_date);
        stockOperation.getStockDayInfoByDate(element.stock_code, price_date, function(flag, result){
            if(flag){
                if(result.length>0){
                    var stockDayInfo = result[0];
                    stockLookYield.look_duration_price = stockDayInfo.price;
                    stockLookYield.look_duration_price_date = stockDayInfo.date;
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
            stockOperation.getAllStockLook(function(flag, result){
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

exports.caculateAvPrice = function(day, nowday){
    stockOperation.getAllStockCode(function(flag, result){
        if(flag){
            result.forEach(function(e){
                stockOperation.getStockDayInfoLessNowDay(e.stock_code, day, nowday, function(flag, result){
                    if(flag){

                        if(result.length>0){
                            var totalPrice = 0;
                            var maxDate = result[0].date;
                            var stock_code = result[0].stock_code;
                            result.forEach(function(e){
                                totalPrice+=e.price;
                                if(maxDate<e.date){
                                    maxDate = e.date;
                                }
                            });
                            console.log(maxDate);
                            var avPrice = totalPrice/result.length;
                            if(day === 5){
                                stockOperation.update5AvPrice(stock_code, avPrice, maxDate, function(flag, result){
                                    if(flag){

                                    }else{
                                        logger.error(result, logger.getFileNameAndLineNum(__filename));
                                    }
                                });
                            }

                            if (day === 10) {
                                stockOperation.update10AvPrice(stock_code, avPrice, maxDate, function(flag, result){
                                    if(flag){

                                    }else{
                                        logger.error(result, logger.getFileNameAndLineNum(__filename));
                                    }
                                });
                            }

                            if (day === 20) {
                                stockOperation.update20AvPrice(stock_code, avPrice, maxDate, function(flag, result){
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

}

//
// exports.caculateUserRank = function(){
//     userOperation.clearUserYieldRank(function(flag, result){
//         if(flag){
//             stockOperation.getUserIdFromLookYield(function(flag, result){
//                 if(flag){
//                     result.forEach(function(element){
//
//                     });
//                 }else{
//                     logger.error(result, logger.getFileNameAndLineNum(__filename));
//                 }
//             });
//         }else{
//             logger.error(result, logger.getFileNameAndLineNum(__filename));
//         }
//     });
// };
