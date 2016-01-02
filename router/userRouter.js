var express = require('express');
var router = express.Router();
var log = global.logger;
var userMgmt = require('../databaseOperation/userOperation.js');
var constant = require('../utility/constant.js');
var routerFunc = require('../utility/routeFunc.js');
var config = require('../config');
var common = require('../utility/commonFunc.js');
var apn = require('../utility/apnPush.js');

module.exports = router;


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
							badge: result[0].count
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
