var mysql = require('mysql');
var conn = require('../utility.js');

var logger = global.logger;
var md5 = require('MD5');

exports.followUser = function(reqbody, callback){
	var follow_timestamp = Date.now();
	var sql = "insert into user_follow_base_info(user_id, followed_user_id, follow_timestamp) " +
	" values(?,?,?)";
	conn.executeSql(sql, [reqbody.user_id, reqbody.followed_user_id, follow_timestamp], callback);

	sql = "update user_base_info set user_follow_count = user_follow_count+1 where user_id = ?";
	conn.executeSql(sql, [reqbody.user_id], null);

	sql = "update user_base_info set user_fans_count = user_fans_count+1 where user_id = ?";
	conn.executeSql(sql, [reqbody.followed_user_id], null);
};

exports.updateUserFace = function(user_id, fileName, callback){
	var sql = "update user_base_info set user_facethumbnail = ? where user_id = ?";
	logger.debug(sql, logger.getFileNameAndLineNum(__filename));
	conn.executeSql(sql, [fileName, user_id], callback);
}

exports.cancelFollowUser = function(reqbody, callback){

	var sql = "delete from user_follow_base_info where user_id = ? and followed_user_id = ?";
	conn.executeSql(sql, [reqbody.user_id, reqbody.followed_user_id], callback);

	sql = "update user_base_info set user_follow_count = user_follow_count-1 where user_id = ?";
	conn.executeSql(sql, [reqbody.user_id], null);

	sql = "update user_base_info set user_fans_count = user_fans_count-1 where user_id = ?";
	conn.executeSql(sql, [reqbody.followed_user_id], null);
};

exports.checkUserNameExist = function(reqBody, callback) {
	var sql = 'select *from user_base_info where user_name = ?';
	conn.executeSql(sql, [reqBody.user_name], callback);
};

exports.getfollowInfo = function(reqbody, callback){
	var sql = "select *From user_follow_base_info where user_id = ?";
	conn.executeSql(sql, [reqbody.user_id], callback);
};

exports.getFansUser = function(reqbody, callback){
	var sql = "select a.follow_timestamp, b.* from user_follow_base_info a, user_base_info b " +
	" where a.user_id = b.user_id and a.followed_user_id = ? and a.follow_timestamp< ? " +
	" order by follow_timestamp desc limit 12 ";
	conn.executeSql(sql, [reqbody.followed_user_id, reqbody.follow_timestamp], callback);
};

exports.getfollowUser = function(reqbody, callback){
	var sql = "select a.follow_timestamp, b.* from user_follow_base_info a, user_base_info b " +
	" where a.followed_user_id = b.user_id and a.user_id = ? and a.follow_timestamp< ? " +
	"order by follow_timestamp desc limit 12 ";
	conn.executeSql(sql, [reqbody.user_id, reqbody.follow_timestamp], callback);
};

exports.getfollowUserAll = function(reqbody, callback){
	var sql = "select a.follow_timestamp, b.* from user_follow_base_info a, user_base_info b " +
	" where a.followed_user_id = b.user_id and a.user_id = ?";
	conn.executeSql(sql, [reqbody.user_id], callback);
};


exports.getUserTokenInfo = function(user_id, callback) {
	var sql = 'select *from user_base_info where user_id = ?';
	conn.executeSql(sql, [user_id], callback);
};

exports.getCertificateCode = function(userPhone, callback) {
	var sql =
		'select *from confirm_phone where user_phone = ? order by time_stamp desc limit 1';
	conn.executeSql(sql, [userPhone], callback);
};

exports.checkPhoneNum = function(userPhone, callback) {
	var sql = 'select user_phone from user_base_info where user_phone = ?';
	conn.executeSql(sql, [userPhone], callback);
};

exports.getCertificateCode = function(userPhone, callback) {

	var sql = 'select *from confirm_phone where user_phone = ? order by time_stamp desc limit 1';
	conn.executeSql(sql, [userPhone], callback);
};

exports.certificateCode = function(userPhone, certificateCode, timeStamp,
	callback) {
	var sql = 'select time_stamp from confirm_phone where user_phone = ? order by time_stamp desc limit 1';
	conn.executeSql(sql, [userPhone], function(flag, result) {
		if (flag) {
			if (result.length) {
				if (timeStamp - result[0].time_stamp > 180000) {
					sql = 'insert into confirm_phone values(?,?,?)';
					conn.executeSql(sql, [userPhone, certificateCode, timeStamp], callback);
				} else {
					callback(true);
				}
			} else {
				sql = 'insert into confirm_phone values(?,?,?)';
				conn.executeSql(sql, [userPhone, certificateCode, timeStamp], callback);
			}
		} else {
			callback(false);
		}
	});
};


exports.login = function(userPhone, password, callback) {
	var sql =
		'select * from user_base_info where user_phone = ? and user_password = ?';
	conn.executeSql(sql, [userPhone, password], callback);
};


exports.register = function(userInfo, callback) {

	var sql = "insert into user_base_info (user_id, user_phone, user_name, user_password) " +
	" values (?,?,?,?) ";
	conn.executeSql(sql, [userInfo.user_id, userInfo.user_phone, userInfo.user_name, userInfo.user_password], callback);
};

exports.getLookStockCountByUser = function(user_id, callback){
	var sql = 'select count(*) as stock_look_count from stock_look_info where user_id = ? ' +
	' and look_status = 1';
	conn.executeSql(sql, [user_id], callback);
}

exports.updateAllUserTotalYield = function(callback){
	var sql = 'UPDATE `user_base_info` a SET a.`user_look_yield` = ' +
	' (SELECT SUM(b.stock_yield) FROM `stock_look_info` b WHERE b.`user_id` = a.`user_id`)';
	conn.executeSql(sql, [], callback);
};

exports.isLook = function(user_id, stock_code, callback){
	var sql = 'select * from stock_look_info where user_id = ? and stock_code = ? and look_status = 1';
	conn.executeSql(sql, [user_id, stock_code], callback);
}

exports.getAllUser = function(callback){
	var sql = 'select *from user_base_info';
	conn.executeSql(sql, [], callback);
};

exports.userBaseInfo = function(user_id, callback){
	var sql = 'select user_id, user_name, user_facethumbnail, ' +
	' user_fans_count, user_follow_count, user_look_yield from user_base_info where user_id = ?';
	conn.executeSql(sql, [user_id], callback);
}

exports.searchUser = function(user_id, user_name, callback){
	user_name = '%'+user_name+'%';
	var sql = 'select user_id, user_name, user_facethumbnail, user_look_yield ' +
	' from user_base_info where user_id<>? and user_name like ? ';
	conn.executeSql(sql, [user_id, user_name], callback);
}

exports.addCommentToLook = function(reqBody, callback){
	var timestamp = Date.now();
	var md5 = require('MD5');
	var comment_id = md5(reqBody.comment_user_id +
		reqBody.comment_to_user_id + reqBody.look_id + timestamp);
	var sql = 'insert into look_comment_info ' +
	'(comment_id, look_id, comment_user_id, comment_to_user_id, ' +
	' comment_content, comment_timestamp, to_look) values(?,?,?,?,?,?,?)';
	conn.executeSql(sql, [comment_id, reqBody.look_id,
		reqBody.comment_user_id,
		reqBody.comment_to_user_id,
		reqBody.comment_content,
		timestamp, reqBody.to_look], callback);

	sql = 'update stock_look_info set comment_count = comment_count+1 where look_id = ?';
	conn.executeSql(sql, [reqBody.look_id], null);
}


exports.getComments = function (look_id, comment_timestamp, callback) {
	var sql = 'select a.*, b.user_name as comment_user_name, ' +
	' b.user_facethumbnail as comment_user_facethumbnail, ' +
	' c.user_name as comment_to_user_name from ' +
	' look_comment_info a, user_base_info b, user_base_info c ' +
	' where a.look_id = ? ' +
	' and a.comment_user_id = b.user_id ' +
	' and a.comment_to_user_id = c.user_id ' +
	' and a.comment_timestamp<? ' +
	' order by a.comment_timestamp DESC limit 12 ';
	console.log(look_id+' '+comment_timestamp);
	conn.executeSql(sql, [look_id, comment_timestamp], callback);
};

exports.clearUserYieldRank = function(){
	var sql = 'TRUNCATE `user_yield_rank`';
    conn.executeSql(sql, [], callback);
}

exports.getRankUser = function(look_duration, callback){
	var sql = 'select b.user_id, c.`user_name`, c.`user_facethumbnail`, ' +
	' b.look_duration, b.total_yield, a.`stock_code`, d.`stock_name` ' +
	' from `stock_look_info` a, ' +
	' `user_base_info` c,' +
	' `stock_base_info` d,' +
	' (SELECT `user_id`,`look_duration` , SUM(`look_yield`) as total_yield  ' +
	' FROM `stock_look_yield` GROUP BY `user_id` , `look_duration` ' +
	' HAVING `look_duration` = ? '+
	' ORDER BY total_yield desc ' +
	' LIMIT 20 ' +
	' ) b ' +
	' WHERE a.`user_id` = b.user_id' +
	' and a.`user_id` = c.`user_id` ' +
	' and a.`stock_code` = d.`stock_code`' +
	' and a.`look_status`  = 1'+
	' ORDER BY b.total_yield desc';
	conn.executeSql(sql, [look_duration], callback);
}


exports.getUnreadCommentCount = function(user_id, callback){
	var sql = 'select count(*) as count from look_comment_info where comment_to_user_id = ? and comment_unread = 1';
	conn.executeSql(sql, [user_id], callback);
}

exports.updateUnreadComment = function(user_id, callback){
	var sql = 'update look_comment_info set comment_unread = 2 where comment_to_user_id = ?';
	conn.executeSql(sql, [user_id], callback);
}

exports.getUnreadComment = function(user_id, comment_timestamp, callback){
	var sql = 'select a.*, b.*, c.user_id as comment_user_id, ' +
	' c.user_name as comment_user_name, c.user_facethumbnail as comment_user_facethumbnail, ' +
	' d.stock_name from look_comment_info a, ' +
	' stock_look_info b, user_base_info c, stock_base_info d ' +
	' where a.comment_to_user_id = ? ' +
	' and a.look_id = b.look_id and a.comment_user_id = c.user_id ' +
	' and b.stock_code = d.stock_code ' +
	' and a.comment_timestamp<? ' +
	' order by a.comment_timestamp desc limit 12';
	conn.executeSql(sql, [user_id, comment_timestamp], callback);
}

exports.updateDeviceToken = function(user_phone, device_token, callback){
	console.log('user_phone:'+user_phone);
	console.log('device_token:'+device_token);
	var sql = 'update user_base_info set device_token = ? where user_phone = ?';
	conn.executeSql(sql, [device_token, user_phone], callback);
}


exports.updateLoginStatus = function(user_id, user_login_status, callback){
	var sql = 'update user_base_info set user_login_status = ? where user_id = ?';
	conn.executeSql(sql, [user_login_status, user_id], callback);
}


exports.addCommentToStock = function(reqBody, callback){

	var talk_timestamp_ms = Date.now();
	var talk_id = md5(reqBody.talk_user_id+reqBody.talk_stock_code+talk_timestamp_ms);

	var sql = 'insert into stock_talk_base_info(talk_id, talk_stock_code, ' +
		' talk_user_id, talk_to_user_id, talk_content, talk_date_time, talk_timestamp_ms) ' +
		' values(?,?,?,?,?,NOW(),?)';
	conn.executeSql(sql, [talk_id, reqBody.talk_stock_code,
		reqBody.talk_user_id, reqBody.talk_to_user_id, reqBody.talk_content,
		talk_timestamp_ms], callback);
}


exports.getCommentToStock = function(talk_stock_code, talk_timestamp_ms, callback){
	var sql = 'select a.*, b.user_name, b.user_facethumbnail from stock_talk_base_info a, user_base_info b' +
	' where a.talk_stock_code = ? and a.talk_timestamp_ms<? ' +
	' and a.talk_user_id = b.user_id order by talk_timestamp_ms desc limit 36';
	conn.executeSql(sql, [talk_stock_code, talk_timestamp_ms], callback);
}
