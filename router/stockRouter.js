var express = require('express');
var router = express.Router();
var logger = global.logger;
var databaseOper = require('../databaseOperation.js');
var constant = require('../utility/constant.js');
var routerFunc = require('../utility/routerFunc.js');
var config = require('../config');
var common = require('../utility/commonFunc.js');

module.exports = router;


router.get('/test', function(req, res) {
	logger.debug('get test');
	res.send('stock test');
});


router.post('/now', function(req, res){
    databaseOper.getStockNowByCode(req.body.stock_code, function(flag, result){
        if(flag){
            if(result.length>0){
                routerFunc.feedBack(constant.returnCode.SUCCESS, result[0], res);
            }else{
                //find in base info
                databaseOper.getStockByCode(req.body.stock_code, function(flag, result){
                    if(flag){
                        if(result.length>0){
                            routerFunc.feedBack(constant.returnCode.SUCCESS, result[0], res);
                        }else{
                            //find in data interface
                            common.getStockInfoFromAPI(req.body.stock_code, function(flag, htmlData){
                                if(flag){
                                    //analyze html data
                                    var stockInfoArr = common.analyzeMessage(htmlData);
                                    if(stockInfoArr == false||stockInfoArr.length == 0){
                                        routerFunc.feedBack(constant.returnCode.STOCK_NOT_EXIST, null, res);
                                    }else{
                                        routerFunc.feedBack(constant.returnCode.SUCCESS, stockInfoArr[0], res);
                                        //insert to stock base info
                                        databaseOper.insertStockBaseInfo(stockInfoArr[0], function(flag, result){
                                            if(!flag){
                                                logger.error(result, logger.getFileNameAndLineNum(__filename));
                                            }
                                        });
                                    }

                                }else{
                                    routerFunc.feedBack(constant.returnCode.ERROR, htmlData, res);
                                }
                            });

                        }
                    }else{
                        logger.error(result, logger.getFileNameAndLineNum(__filename));
                        routerFunc.feedBack(constant.returnCode.ERROR, result, res);
                    }
                });
            }

        }else{
            logger.error(result, logger.getFileNameAndLineNum(__filename));
            routerFunc.feedBack(constant.returnCode.ERROR, result, res);
        }
    });
});
