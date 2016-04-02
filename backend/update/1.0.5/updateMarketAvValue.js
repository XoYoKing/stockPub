//补全为空的均指数
var log = require('../../log.js');
var stockOperation = require('../../databaseOperation/stockOperation');
log.SetLogFileName('updateMarketAvValue');

stockOperation.getAllMarketIndexDay(function(flag, result){
    if(flag){
        result.forEach(function(e){
            {
                console.log(e.market_code+' '+e.market_index_date+ " update ");
                stockOperation.getMarketDayInfoLessNowDay(e.market_code, 20, e.market_index_date,
                function(flag, result){
                    if(flag){
                        var totalTwenty = 0;
                        if(result.length === 20){
                            for (var i = 0; i < result.length; i++) {
                                totalTwenty+=result[i].market_index_value_now;
                            }
                            totalTwenty/=result.length;
                        }


                        var totalTen = 0;
                        if(result.length>=10){
                            for (var i = 0; i<10; i++) {
                                totalTen+=result[result.length - i - 1].market_index_value_now;
                            }
                            totalTen/=10;
                        }


                        var totalFive = 0;
                        if(result.length>=5){
                            for (var i = 0; i < 5; i++) {
                                totalFive+=result[result.length - i - 1].market_index_value_now;
                            }
                            totalFive/=5;
                        }

                        stockOperation.updateMarket5AvPrice(e.market_code, totalFive, e.market_index_date, function(flag, result){
                            if(!flag){
                                log.error(result);
                            }
                        });
                        stockOperation.updateMarket10AvPrice(e.market_code, totalTen, e.market_index_date, function(flag, result){
                            if(!flag){
                                log.error(result);
                            }
                        });
                        stockOperation.updateMarket20AvPrice(e.market_code, totalTwenty, e.market_index_date, function(flag, result){
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
