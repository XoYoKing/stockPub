var express = require('express');
var router = express.Router();
var log = global.logger;
var userMgmt = require('../databaseOperation/userOperation.js');
var constant = require('../utility/constant.js');
var routerFunc = require('../utility/routeFunc.js');
var common = require('../utility/commonFunc.js');
var apn = require('../utility/apnPush.js');
var config = require('../config');
var formidable = require('formidable');
var path = require('path');
var apn = require('../utility/apnPush.js');
var md5 = require('MD5');
var redis = require("redis");
var redisClient = redis.createClient({auth_pass:'here_dev'});

redisClient.on("error", function (err) {
	log.error(err, log.getFileNameAndLineNum(__filename));
});

var asyncClient = require('async');


module.exports = router;



router.post('/cancelFollowUser', function(req, res){
	userMgmt.cancelFollowUser(req.body, function(flag, result){
		var returnData = {};
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/getfollowUserAll', function(req, res){
	userMgmt.getfollowUserAll(req.body, function(flag, result){
		var returnData = {};
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/getfollowUser', function(req, res){
	userMgmt.getfollowUser(req.body, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/getFansUser', function(req, res){
	userMgmt.getFansUser(req.body, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);

		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/getfollowInfo', function(req, res){
	userMgmt.getfollowInfo(req.body, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);

		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/followUser', function(req, res){
	userMgmt.followUser(req.body, function(flag, result){
		var returnData = {};
		if(!flag){
			if(result.code === 'ER_DUP_ENTRY'){
				returnData.code = constant.returnCode.FOLLOW_USER_EXIST;
			}else{
				log.error(result, log.getFileNameAndLineNum(__filename), req.body.sq);
				returnData.code = constant.returnCode.ERROR;
			}
		}else{
			returnData.code = constant.returnCode.SUCCESS;

			//apn 推送给被关注的人消息
			userMgmt.getUserTokenInfo(req.body.followed_user_id, function(flag, result) {
				if (flag) {
					if (result.length > 0) {
						var pushMsg = {
							content: req.body.user_name + '关注了你',
							msgtype: 'msg',
							badge: 1
						};
						// apn to user
						apn.pushMsgToUsers(result[0].device_token, pushMsg);
					} else {
						log.warn(req.body.followed_user_id + ' has no device token', log.getFileNameAndLineNum(
							__filename));
					}
				} else {
					log.error(result, log.getFileNameAndLineNum(__filename));
				}
			});

		}
		res.send(returnData);
	});
});

// register
router.post('/register', function(req, res) {
	var returnData = {};
	var fields = req.body;
	userMgmt.getCertificateCode(fields.user_phone, function(flag, result) {
		if (flag) {
			if (result.length === 0) {
				log.debug('no certificateCode for phone:' + fields.user_phone, log.getFileNameAndLineNum(
					__filename));
				returnData.code = constant.returnCode.CERTIFICATE_CODE_NOT_MATCH;
				res.send(returnData);
				return;
			}

			var certificateInfo = result[0];

			if (certificateInfo.certificate_code === fields.user_certificate_code) {
				var user_info = {};
				user_info.user_id = md5(fields.user_phone);
				user_info.user_phone = fields.user_phone;
				user_info.user_name = fields.user_name;
				user_info.user_password = fields.user_password;

				userMgmt.register(user_info, function(flag, result) {
					if (flag) {
						log.debug('REGISTER_SUCCESS', log.getFileNameAndLineNum(__filename));
						returnData = {
							'user_phone': user_info.user_phone,
							'user_id': user_info.user_id,
							'user_name': user_info.user_name,
							'code': constant.returnCode.REGISTER_SUCCESS
						};
					} else {
						if(result.code === 'ER_DUP_ENTRY'){
							returnData.code = constant.returnCode.PHONE_EXIST;
						}else{
							log.error(result, log.getFileNameAndLineNum(__filename));
							returnData.code = constant.returnCode.ERROR;
						}
					}
					res.send(returnData);
				});

			} else {
				log.debug(fields.user_certificate_code + ' not equal to ' +
					certificateInfo.certificate_code, log.getFileNameAndLineNum(
						__filename));
				returnData.code = constant.returnCode.CERTIFICATE_CODE_NOT_MATCH;
				res.send(returnData);
			}

		} else {
			log.error(result, log.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
			res.send(returnData);
		}
	});
});


// get the verifying code from phone number
router.post('/confirmPhone', function(req, res) {
	// log.logPrint(constant.logLevel.INFO, JSON.stringify(req.body));

	userMgmt.checkPhoneNum(req.body.user_phone, function(flag, result) {
		var statusCode;
		var returnData = {
			'user_phone': req.body.user_phone,
			'code': 0
		};

		if (flag && result.length) {
			log.debug(req.body.user_phone + ' PHONE_EXIST', log.getFileNameAndLineNum(
				__filename));
			statusCode = constant.returnCode.PHONE_EXIST;
			returnData.code = statusCode;
			res.send(returnData);
		} else if (flag) {

			var certificateCode = (Math.random() * 10000).toFixed(
				0);
			var timestamp = new Date().getTime();
			userMgmt.certificateCode(req.body.user_phone, certificateCode, timestamp,
				function(flag, result) {

					if (flag && result) {
						statusCode = constant.returnCode.CERTIFICATE_CODE_SEND;
						var weimi = require('../utility/weimi');
						weimi.sendMessage(req.body.user_phone, certificateCode, function(
							result) {
							log.debug(result, log.getFileNameAndLineNum(__filename));
							returnData.code = statusCode;
							res.send(returnData);
						});
					} else if (flag) {
						statusCode = constant.returnCode.CERTIFICATE_CODE_SENDED;
						returnData.code = statusCode;
						res.send(returnData);
					} else {
						log.error(result, log.getFileNameAndLineNum(__filename));
						statusCode = constant.returnCode.ERROR;
						returnData.code = statusCode;
						res.send(returnData);
					}
				});
		} else {
			log.error(result, log.getFileNameAndLineNum(__filename));
			statusCode = constant.returnCode.ERROR;
			returnData.code = statusCode;
			res.send(returnData);
		}
	});
});


router.post('/checkNameExist', function(req, res) {
	userMgmt.checkUserNameExist(req.body, function(flag, result) {
		var returnData = {};
		if (flag) {
			if (result.length > 0) {
				log.debug(req.body.user_name + ' USER_EXIST', log.getFileNameAndLineNum(
					__filename));
				returnData.code = constant.returnCode.USER_EXIST;
			} else {
				log.debug(req.body.user_name + ' USER_NOT_EXIST', log.getFileNameAndLineNum(
					__filename));
				returnData.code = constant.returnCode.USER_NOT_EXIST;
			}
		} else {
			log.error(result, log.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
		}
		res.send(returnData);
	});
});

//change face
router.post('/changeFace', function(req, res){
	log.debug('enter changeFace', log.getFileNameAndLineNum(__filename));

	var form = new formidable.IncomingForm();
	form.parse(req, function(err, fields, files) {
		var returnData = {};

		if (err) {
			log.error('form.parse error', log.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
			res.send(returnData);
			return;
		}

		var fileName = files.user_image.path + Date.now();
		var encrypt = require('../utility/encrypt.js');
		fileName = encrypt.sha1Cryp(fileName);
		var fs = require('fs');
		fs.rename(files.user_image.path, path.join(process.env.HOME,
			config.stockPubFaceDir.dir, fileName), function(err) {
			if (err) {
				log.error('fs.rename error ' + err, log.getFileNameAndLineNum(__filename));
				returnData.code = constant.returnCode.ERROR;
				res.send(returnData);
			} else {
				log.debug(fields.user_id+" "+fileName, log.getFileNameAndLineNum(__filename));
				userMgmt.updateUserFace(fields.user_id, fileName,
					function(flag, result) {
						if (flag) {
							returnData.code = constant.returnCode.SUCCESS;
							returnData.data = {
								'fileName':fileName
							};
						} else {
							log.error('insertUserImageInfo error ' +
								result, log.getFileNameAndLineNum(__filename));
							returnData.code = constant.returnCode.ERROR;
						}
						res.send(returnData);
					});
			}
		});
	});
});


// login
router.post('/login', function(req, res) {
	userMgmt.login(req.body.user_phone, req.body.user_password, function(flag, result) {
		var statusCode;
		var returnData = {
			data:'',
			code:''
		};
		if (flag) {
			if (result.length) {
				statusCode = constant.returnCode.LOGIN_SUCCESS;
				var data = result[0];
				returnData.data = data;
				returnData.code = statusCode;
				log.debug(returnData, log.getFileNameAndLineNum(__filename));
				res.send(returnData);

				userMgmt.updateLoginStatus(data.user_id, 1, function(flag, result){
					if(!flag){
						log.error(result, log.getFileNameAndLineNum(__filename));
					}
				});
			} else {
				statusCode = constant.returnCode.LOGIN_FAIL;
				var data = {
					'user_phone': req.body.user_phone,
				};
				returnData.code = statusCode;
				returnData.data = data;

				log.debug(returnData, log.getFileNameAndLineNum(__filename));
				res.send(returnData);
			}
		} else {
			log.error(result, log.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
			res.send(returnData);
		}
	});
});


router.post('/logout', function(req, res){
	userMgmt.updateLoginStatus(req.body.user_id, 0, function(flag, result){
		if(!flag){
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}else{
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}
	});
});


//get user base info
router.post('/userBaseInfo', function(req, res){
	userMgmt.userBaseInfo(req.body.user_id, function(flag, result){
		var returnData = {};
		if(flag){
			returnData.code = constant.returnCode.SUCCESS;
			if(result.length>0){
				returnData.data = result[0];
			}
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
		}
		res.send(returnData);
	});
});


//search user
router.post('/searchUser', function(req, res){
	userMgmt.searchUser(req.body.user_id, req.body.user_name, function(flag, result){
		var returnData = {};
		if(flag){
			returnData.code = constant.returnCode.SUCCESS;
			returnData.data = result;
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			returnData.code = constant.returnCode.ERROR;
		}
		res.send(returnData);
	});
});


router.get('/eula', function(req, res){
	res.render('eula');
});



//comment
// add by wanghan 20160202 for add active comment
router.post('/addCommentToLook', function(req, res) {
	userMgmt.addCommentToLook(req.body, function(flag, result) {
		if (flag) {
			// apn
			if (req.body.comment_user_id === req.body.comment_to_user_id) {
				log.debug('not to apn', log.getFileNameAndLineNum(__filename));
			} else {
				var msg = req.body.comment_user_name + '评论了你';
				apn.pushMsg(req.body.comment_to_user_id, msg);
				//apnToUser(req.body.to_user_id, req.body.user_name + '评论了你');
				//redisOper.increaseUnreadCommentCount(req.body.to_user_id);
			}
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}

	});
});

router.post('/getComments', function(req, res){
	userMgmt.getComments(req.body.look_id, req.body.comment_timestamp, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else {
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});


router.post('/getRankUser', function(req, res){
	userMgmt.getRankUser(req.body.look_duration, function(flag, result){
		var userlist = {};
		if(flag){
			result.forEach(function(element){
				if(userlist[element.user_id] == null){
					userlist[element.user_id] =
					{
						user_id: element.user_id,
						user_name: element.user_name,
						user_facethumbnail: element.user_facethumbnail,
						total_yield: element.total_yield,
						stocklist: [{
							stock_code: element.stock_code,
							stock_name: element.stock_name
						}]
					};
				}else{
					userlist[element.user_id].stocklist.push({
						stock_code: element.stock_code,
						stock_name: element.stock_name
					});
				}
			});

			routerFunc.feedBack(constant.returnCode.SUCCESS, userlist, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});


router.post('/getUnreadCommentCount', function(req, res){

	asyncClient.parallel({
		unreadCommentCount: function(callback){
			userMgmt.getUnreadCommentCount(req.body.user_id, function(flag, result){
				if(flag){
					var count = result[0].count;
					log.debug(req.body.user_id+' unread count: '+count, log.getFileNameAndLineNum(__filename));
					callback(null, count);
				}else{
					log.error(result, log.getFileNameAndLineNum(__filename));
					callback(result);
				}
			});
		},
		unreadCommentToStockCount: function(callback){
			redisClient.hget(config.hash.stockUnreadCommentCountHash, req.body.user_id, function(err, reply){
				if(err){
					log.error(err, log.getFileNameAndLineNum(__filename));
					callback(err);
				}else{
					if(reply == null){
						reply = 0;
					}
					callback(null, reply);
				}
			});
		}
	},function(err, results){
		if(err){
			log.error(err, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, err, res);
		}else{
			routerFunc.feedBack(constant.returnCode.SUCCESS, results, res);
		}
	});
});


router.post('/getUnreadComment', function(req, res){
	userMgmt.getUnreadComment(req.body.user_id, req.body.comment_timestamp, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
			userMgmt.updateUnreadComment(req.body.user_id, function(flag, result){
				if(!flag){
					log.error(result, log.getFileNameAndLineNum(__filename));
				}
			});
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/updateUnreadComment', function(req, res){
	userMgmt.updateUnreadComment(req.body.user_id, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});


router.post('/updateDeviceToken', function(req, res){
	userMgmt.updateDeviceToken(req.body.user_phone, req.body.device_token, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});


router.post('/getCommentToStockByUser', function(req, res){
	userMgmt.getCommentToStockByUser(req.body.user_id, req.body.talk_timestamp_ms, function(flag, result){
		if(flag){

			//获取当前股票股价
			asyncClient.each(result, function(item, callback){
				var hash = null;
				if(item.talk_stock_code.indexOf('sz')!=-1||
				item.talk_stock_code.indexOf('sh')!=-1){
					hash = config.hash.marketCurPriceHash;
				}else{
					hash = config.hash.stockCurPriceHash;
				}

				redisClient.hget(hash, item.talk_stock_code, function(err, reply){
					if(err){
						log.error(result, log.getFileNameAndLineNum(__filename));
						callback(err);
					}else{
						item.stockInfo = reply;
						callback(null);
					}
				});

			}, function done(err){
				if(err){
					log.error(err, log.getFileNameAndLineNum(__filename));
					routerFunc.feedBack(constant.returnCode.ERROR, result, res);
				}else{
					//log.debug(JSON.stringify(result), log.getFileNameAndLineNum(__filename));
					routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
				}
			});

		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});

	//remove redis count
	clearUnreadStockCommentCount(req.body.user_id);
});


router.post('/getCommentToStock', function(req, res){
	userMgmt.getCommentToStock(req.body.talk_stock_code, req.body.talk_timestamp_ms, function(flag, result){
		if(flag){
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);
		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});
});

router.post('/addCommentToStock', function(req, res){
	//插入数据库
	userMgmt.addCommentToStock(req.body, function(flag, result){
		if (flag) {
			routerFunc.feedBack(constant.returnCode.SUCCESS, result, res);

			//更新未读评论数
			if(req.body.to_stock == 0){
				increaseUnreadStockCommentCount(req.body.talk_to_user_id);
			}

		}else{
			log.error(result, log.getFileNameAndLineNum(__filename));
			routerFunc.feedBack(constant.returnCode.ERROR, result, res);
		}
	});

	//推送
	if(req.body.to_stock == 0){
		var msg = req.body.user_name + '评论了你';
		apn.pushMsg(req.body.talk_to_user_id, msg);
	}
});


function clearUnreadStockCommentCount(user_id){
	redisClient.hset(config.hash.stockUnreadCommentCountHash, user_id, 0, function(err, reply){
		if(err){
			log.error(err, log.getFileNameAndLineNum(__filename));
		}
	});
}

function increaseUnreadStockCommentCount(user_id){
	redisClient.hget(config.hash.stockUnreadCommentCountHash, user_id, function(err, reply){
		if(err){
			log.error(err, log.getFileNameAndLineNum(__filename));
		}else{
			if(reply == null){
				reply = 1;
			}else{
				reply=parseInt(reply)+1;
			}
			redisClient.hset(config.hash.stockUnreadCommentCountHash, user_id, reply, function(err, reply){
				if(err){
					log.error(err, log.getFileNameAndLineNum(__filename));
				}
			});
		}
	});
}
