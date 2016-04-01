
var domain = require('domain');
var domainObj = domain.create();
var log = global.logger;
if(log === undefined){
	log = global.log;
}

var userMgmt = require('../databaseOperation/userOperation.js');
var path = require('path');

exports.pushMsg = function(user_id, msg){
	userMgmt.getUserTokenInfo(user_id, function(flag, result) {
		if (flag) {
			if (result.length > 0) {
				var pushMsg = {
					content: msg,
					msgtype: 'msg',
					badge: 1
				};
				// apn to user
				pushMsgToUsers(result[0].device_token, pushMsg);
			} else {
				if(log !==undefined){
					log.warn(user_id + ' has no device token', log.getFileNameAndLineNum(
						__filename));
				}
			}
		} else {
			log.error(result, log.getFileNameAndLineNum(__filename));
		}
	});
}



exports.pushMsgToUsers = pushMsgToUsers;

function pushMsgToUsers(userToken, msg) {
	if (userToken === undefined || userToken === ''||userToken === null) {
		if(log!== undefined){
			log.warn('userToken is null', log.getFileNameAndLineNum(__filename));
		}
		return;
	}

	var pemName = '';
	var pemkeyName = '';
	var gateway = '';
	if (process.env.STOCK_ENV === 'dev') {
		pemName = 'StockPub.pem';
		pemkeyName = 'StockPubKey.pem';
		gateway = 'gateway.sandbox.push.apple.com';
	}

	if (process.env.STOCK_ENV === 'pro') {
		pemName = 'StockPubPro.pem';
		pemkeyName = 'StockPubKey.pem';
		gateway = 'gateway.push.apple.com';
	}


	//log.debug(path.join(__dirname, pemName), log.getFileNameAndLineNum(__filename));
	//log.debug(path.join(__dirname, pemkeyName), log.getFileNameAndLineNum(__filename));
	//log.debug(msg, log.getFileNameAndLineNum(__filename));

	var apns = require('apn');
	var options = {
		cert: path.join(__dirname, pemName),
		key: path.join(__dirname, pemkeyName),
		passphrase: '123456',
		/* Key file path */
		gateway: gateway,
		/* gateway address */
		port: 2195,
		/* gateway port */
		errorCallback: apnErrorHappened
		/* Callback when error occurs function(err,notification) */
	};

	domainObj.run(function () {
		var apnsConnection = new apns.Connection(options);
		var token = userToken;
		var myDevice = new apns.Device(token);
		var note = new apns.Notification();
		note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
		note.badge = msg.badge + 1;
		note.alert = msg.content;
		note.payload = msg;
		note.device = myDevice;
		apnsConnection.sendNotification(note);
		log.debug('send notification to ' + userToken, log.getFileNameAndLineNum(__filename));
	});
}

// exports.apnPushTo = function(user_id, msg, badgeCount){

// }

function apnErrorHappened (err, notification) {
	// var Errors = {
// 	"noErrorsEncountered": 0,
// 	"processingError": 1,
// 	"missingDeviceToken": 2,
// 	"missingTopic": 3,
// 	"missingPayload": 4,
// 	"invalidTokenSize": 5,
// 	"invalidTopicSize": 6,
// 	"invalidPayloadSize": 7,
// 	"invalidToken": 8,
// 	"apnsShutdown": 10,
// 	"none": 255,
// 	"retryLimitExceeded": 512,
// 	"moduleInitialisationFailed": 513,
// 	"connectionRetryLimitExceeded": 514, // When a connection is unable to be established. Usually because of a network / SSL error this will be emitted
// 	"connectionTerminated": 515
// };
	if (err === 8) {
		log.warn('err code:' + err + ' ' + JSON.stringify(notification), log.getFileNameAndLineNum(__filename));
	}else {
		log.warn('err code:' + err + ' ' + JSON.stringify(notification), log.getFileNameAndLineNum(__filename));
	}
}

domainObj.on('error', function (err) {
	log.error(err, log.getFileNameAndLineNum(__filename));
});
