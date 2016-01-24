var express = require('express');
var router = express.Router();
var logger = global.logger;
var databaseOper = require('../databaseOperation.js');
var constant = require('../utility/constant.js');
var routerFunc = require('../utility/routeFunc.js');
var config = require('../config');
var common = require('../utility/commonFunc.js');
var stockOperation = require('../databaseOperation/stockOperation.js');
var userOperation = require('../databaseOperation/userOperation.js');
var apn = require('../utility/apnPush.js');
var asyncClient = require('async');

module.exports = router;


router.get('/test', function(req, res) {
	logger.debug('get test');
	res.send('stock test');
});




//取消看多股票
router.post('/dellook', function(req, res){
	var returnData = {};
	stockOperation.dellookStock(req.body, function(flag, result){
		if(flag){
			returnData.code = constant.returnCode.SUCCESS;
			userOperation.getfollowUserAll(req.body, function(flag, result){
				if(flag){
					result.forEach(function(element){
						var msg = '';
						msg = req.body.user_name+"取消看多"+req.body.stock_name+"("+
							req.body.stock_code+")";
						apn.pushMsg(element.user_id, msg);
					});
				}else{
					logger.error(result, logger.getFileNameAndLineNum(__filename));
				}
			});

		}else{
			returnData.code = constant.returnCode.ERROR;
			logger.error(result, logger.getFileNameAndLineNum(__filename));
		}
		res.send(returnData);
	});
});


//看多股票
router.post('/addlook', function(req, res, next){
	//检查是否已看多
	var returnData = {};
	userOperation.isLook(req.body.user_id, req.body.stock_code, function(flag, result){
		if(flag){
			if(result.length>0){
				logger.info(req.body.user_id + 'already look ' + req.body.stock_code, logger.getFileNameAndLineNum(__filename));
				returnData.code = constant.returnCode.LOOK_STOCK_EXIST;
				res.send(returnData);
			}else{
				next();
			}
		}else{
			logger.error(result, logger.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
			res.send(returnData);
		}
	});
});
router.post('/addlook', function(req, res){
	var returnData = {};
	userOperation.getLookStockCountByUser(req.body.user_id, function(flag, result){
		if(flag){
			logger.debug(JSON.stringify(result), logger.getFileNameAndLineNum(__filename));

			if(result.length>=1&&result[0].stock_look_count>=5){
				//当前看多股票不能多于5支
				logger.info(req.body.user_id+ ' 当前看多股票不能多于5支', logger.getFileNameAndLineNum(__filename));
				returnData.code = constant.returnCode.LOOK_STOCK_COUNT_OVER;
				res.send(returnData);
			}else{
				common.getStockInfoFromAPI(req.body.stock_code, function(flag, htmlData){
					if(flag){
						var stockInfoArr = common.analyzeMessage(htmlData);
						if(stockInfoArr == false||stockInfoArr.length == 0){
							returnData.code = constant.returnCode.STOCK_NOT_EXIST;
							res.send(returnData);
						}else{
							req.body.look_stock_price = stockInfoArr[0].price;
							logger.debug(JSON.stringify(req.body), logger.getFileNameAndLineNum(__filename));

							stockOperation.addlookStock(req.body, function(flag, result){
								if(flag){
									returnData.code = constant.returnCode.SUCCESS;

									//推送到关注者
									userOperation.getfollowUserAll(req.body, function(flag, result){
										if(flag){
											result.forEach(function(element){
												var msg = '';
												if(req.body.look_direct == 1){
													msg = req.body.user_name+"看多"+req.body.stock_name+"("+
													req.body.stock_code+")";
												}
												apn.pushMsg(element.user_id, msg);
											});

										}else{
											logger.error(result, logger.getFileNameAndLineNum(__filename));
										}
									});

								}else{
									if(result.code == 'ER_DUP_ENTRY'){
										returnData.code = constant.returnCode.LOOK_STOCK_EXIST;
									}else{
										returnData.code = constant.returnCode.ERROR;
										logger.error(result, logger.getFileNameAndLineNum(__filename));
									}
								}
								res.send(returnData);
							});
						}
					}else{
						logger.error(result, logger.getFileNameAndLineNum(__filename));
						returnData.code = constant.returnCode.ERROR;
						res.send(returnData);
					}
				});
			}
		}else{
			logger.error(result, logger.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
			res.send(returnData);
		}
	});
});


//获取特定人的当前看多
router.post('/getLookInfoByUser', function(req, res){
	var returnData = {};
	stockOperation.getLookInfoByUser(req.body.user_id, 1, function(flag, result){
		if(flag){
			returnData.code = constant.returnCode.SUCCESS;
			returnData.data = result;
		}else{
			logger.error(result, logger.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
		}
		res.send(returnData);
	});
});

//获取特定人的历史看多


//获取关注的人的看多信息
router.post('/getFollowLookInfo', function(req, res){
	stockOperation.getFollowLookInfo(req.body, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
			logger.error(result, logger.getFileNameAndLineNum(__filename));
		}
	});
});


//获取股票列表信息
router.post('/getStockListInfo', function(req, res){
	var stockInfo = {};
	var stocklist = new Array();
	stocklist = req.body['stocklist[]'].slice(0);

	asyncClient.each(stocklist, function(item, callback){
		var reqbody = {};
		reqbody.stock_code = item;
		logger.debug(reqbody.stock_code, logger.getFileNameAndLineNum(__filename));
		stockOperation.getStockInfo(reqbody, function(flag, result){
			logger.debug(item+' '+result, logger.getFileNameAndLineNum(__filename));
			if(flag){
				if(result.length>=1){
					stockInfo[item] = result[0];
					callback();
				}else{
					common.getStockInfoFromAPI(reqbody.stock_code, function(flag, htmlData){
						if(flag){
							var stockInfoArr = common.analyzeMessage(htmlData);
							if(stockInfoArr == false||stockInfoArr.length == 0){

							}else{
								stockInfo[item] = stockInfoArr[0];
							}
						}else{
							logger.error(result, logger.getFileNameAndLineNum(__filename));
						}
						callback();
					});
				}
			}else{
				logger.error(result, logger.getFileNameAndLineNum(__filename));
				callback();
			}
		});

	}, function done (){
		var returnData = {};
		returnData.code = constant.returnCode.SUCCESS;
		returnData.data = stockInfo;
		logger.debug(JSON.stringify(returnData.data));
		res.send(returnData);
	});
});



//获取股票信息
router.post('/getStock', function(req, res){
	stockOperation.getStockInfo(req.body, function(flag, result){
		var returnData = {};
		if(flag){
			logger.debug(result, logger.getFileNameAndLineNum(__filename));
			if(result.length >= 1){
				returnData.data = result[0];
				returnData.code = constant.returnCode.SUCCESS;
				res.send(returnData);
			}else{
				//表中未找到记录
				common.getStockInfoFromAPI(req.body.stock_code, function(flag, htmlData){
					if(flag){
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
						logger.error(result, logger.getFileNameAndLineNum(__filename));
						returnData.code = constant.returnCode.ERROR;
						res.send(returnData);
					}
				});
			}

		}else{
			logger.error(result, logger.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
			res.send(returnData);
		}
	});
});


//获取股票当前行情
router.post('/now', function(req, res){

    logger.debug(JSON.stringify(req.body), logger.getFileNameAndLineNum(__filename));

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
