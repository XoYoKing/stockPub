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
				var md5 = require('MD5');
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
				userMgmt.updateUserFace(fields.user_id, fileName,
					function(flag, result) {
						if (flag) {
							returnData.code = constant.returnCode.SUCCESS;
							returnData.user_image_url = url;
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
				var data = {
					'user_phone': result[0].user_phone,
					'user_id': result[0].user_id,
					'user_password': result[0].user_password,
					'user_name': result[0].user_name,
					'user_facethumbnail': result[0].user_facethumbnail,
					'user_face_image': result[0].user_face_image,
					'fans_count': result[0].user_fans_count,
					'user_follow_count': result[0].user_follow_count,
				};

				returnData.data = data;
				returnData.code = statusCode;
				log.debug(returnData, log.getFileNameAndLineNum(__filename));
				res.send(returnData);

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
