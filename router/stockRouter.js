var express = require('express');
var router = express.Router();
var logger = global.logger;
var databaseOper = require('databaseOperation.js');
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
                routerFunc.feedBack(flag, result[0], res);
            }else{
                //find in base info
                databaseOper.getStockByCode(req.body.stock_code, function(flag, result){
                    if(flag){
                        if(result.length>0){
                            routerFunc.feedBack(flag, result[0], res);
                        }else{
                            //find in data interface
                            common.getStockInfoFromAPI(req.body.stock_code, function(flag, htmlData){
                                if(flag){
                                    //analyze html data


                                }else{
                                    routerFunc.feedBack(flag, htmlData, res);
                                }
                            });

                        }
                    }else{
                        logger.error(result, logger.getFileNameAndLineNum(__filename));
                        routerFunc.feedBack(flag, result, res);
                    }
                });
            }

        }else{
            logger.error(result, logger.getFileNameAndLineNum(__filename));
            routerFunc.feedBack(flag, result, res);
        }
    });
});
