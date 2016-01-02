var express = require('express');
var router = express.Router();
var log = global.logger;
var userMgmt = require('../databaseOperation/userOperation.js');
var constant = require('../utility/constant.js');
var routerFunc = require('../utility/routeFunc.js');
var common = require('../utility/commonFunc.js');
var apn = require('../utility/apnPush.js');

module.exports = router;



router.post('/cancelFollowUser', function(req, res){
	userMgmt.cancelFollowUser(req.body, function(flag, result){
		routeFunc.feedBack(flag, result, res);
	});
});

router.post('/getfollowUser', function(req, res){
	userMgmt.getfollowUser(req.body, function(flag, result){
		routeFunc.feedBack(flag, result, res, req.body.sq);
	});
});

router.post('/getFansUser', function(req, res){
	userMgmt.getFansUser(req.body, function(flag, result){
		routeFunc.feedBack(flag, result, res, req.body.sq);
	});
});

router.post('/getfollowInfo', function(req, res){
	userMgmt.getfollowInfo(req.body, function(flag, result){
		routeFunc.feedBack(flag, result, res, req.body.sq);
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
				returnData.code = contant.returnCode.CERTIFICATE_CODE_NOT_MATCH;
				res.send(returnData);
				return;
			}

			var certificateInfo = result[0];

			if (certificateInfo.certificate_code === fields.user_certificate_code) {
				var user_info = {};
				var md5 = require('MD5');
				user_info.id = md5(fields.user_phone);
				user_info.user_phone = fields.user_phone;
				user_info.name = fields.user_name;
				user_info.password = fields.user_password;

				userMgmt.register(user_info, function(flag, result) {
					if (flag) {
						log.debug('REGISTER_SUCCESS', log.getFileNameAndLineNum(__filename));
						returnData = {
							'user_phone': user_info.user_phone,
							'user_id': user_info.id,
							'user_name': user_info.name,
							'code': contant.returnCode.REGISTER_SUCCESS
						};
					} else {
						log.error(result, log.getFileNameAndLineNum(__filename));
						returnData = {
							'user_phone': fields.user_phone,
							'code': contant.returnCode.REGISTER_FAIL
						};
					}
					res.send(returnData);
				});

			} else {
				log.debug(fields.user_certificate_code + ' not equal to ' +
					certificateInfo.certificate_code, log.getFileNameAndLineNum(
						__filename));
				returnData.code = contant.returnCode.CERTIFICATE_CODE_NOT_MATCH;
				res.send(returnData);
			}

		} else {
			log.error(result, log.getFileNameAndLineNum(__filename));
			returnData.code = contant.returnCode.ERROR;
			res.send(returnData);
		}
	});
});
