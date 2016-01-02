var mysql = require('mysql');
var conn = require('../utility.js');

var logger = global.logger;

exports.followUser = function(reqbody, callback){
	var follow_timestamp = Date.now() / 1000;
	var sql = "insert into user_follow_base_info(user_id, followed_user_id, follow_timestamp) " +
	" values(?,?,?)";
	conn.executeSql(sql, [reqbody.user_id, reqbody.followed_user_id, follow_timestamp], callback);

	sql = "update user_base_info set user_follow_count = user_follow_count+1 where user_id = ?";
	conn.executeSql(sql, [reqbody.user_id], null);

	sql = "update user_base_info set user_fans_count = user_fans_count+1 where user_id = ?";
	conn.executeSql(sql, [reqbody.followed_user_id], null);
};

exports.getUserTokenInfo = function(user_id, callback) {
	var sql = 'select *from user_token_v where user_id = ?';
	conn.executeSql(sql, [user_id], callback);
};
