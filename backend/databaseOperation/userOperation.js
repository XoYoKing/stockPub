var mysql = require('mysql');
var conn = require('../utility.js');

var logger = global.logger;

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
