//补全为空的均指数
var log = require('../../log.js');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('updateMarketAvValue');

stockOperation.getAllMarketIndexDay(function(flag, result){
    if(flag){
        result.forEach(function(e){
            if(e.market_index_five_av_value === null){
                console.log(e.market_code+' '+e.market_index_date+ " update ");
                stockOperation.getMarketDayInfoLessNowDay(e.market_code, 20, e.market_index_date,
                function(flag, result){
                    if(flag){
                        var totalTwenty = 0;
                        for (var i = 0; i < result.length; i++) {
                            totalTwenty+=result[i].market_index_value_now;
                        }

                        var totalTen = 0;
                        for (var i = 10; i < result.length; i++) {
                            totalTen+=result[i].market_index_value_now;
                        }

                        var totalFive = 0;
                        for (var i = 15; i < result.length; i++) {
                            totalFive+=result[i].market_index_value_now;
                        }

                        stockOperation.updateMarket5AvPrice(e.market_code, totalFive/5, e.market_index_date, function(flag, result){
                            if(!flag){
                                log.error(result);
                            }
                        });
                        stockOperation.updateMarket10AvPrice(e.market_code, totalTen/10, e.market_index_date, function(flag, result){
                            if(!flag){
                                log.error(result);
                            }
                        });
                        stockOperation.updateMarket20AvPrice(e.market_code, totalTwenty/20, e.market_index_date, function(flag, result){
                            if(!flag){
                                log.error(result);
                            }
                        });

                    }else{
                        log.error(result);
                    }
                });

            }
        })
    }else{
        log.error(result);
    }
});
