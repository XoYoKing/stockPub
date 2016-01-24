var mysql = require('mysql');
var conn = require('../utility.js');

var logger = global.logger;

exports.addlookStock = function(reqbody, callback){

    var look_timestamp = Date.now();

    var sql = 'insert into stock_look_info(user_id, stock_code, look_direct, look_stock_price, look_time, look_timestamp) ' +
    'values(?, ?, ?, ?, NOW(), ?)';
    conn.executeSql(sql, [reqbody.user_id, reqbody.stock_code,
        reqbody.look_direct, reqbody.look_stock_price, look_timestamp], callback);
};

exports.dellookStock = function(reqbody, callback){
    var look_finish_timestamp = Date.now();

    sql = 'update stock_look_info set look_finish_timestamp = ?, look_finish_time = NOW(), look_status = 2  ' +
    ' where user_id = ? and stock_code = ? and look_status = 1';

    conn.executeSql(sql, [look_finish_timestamp, reqbody.user_id, reqbody.stock_code], callback);
}

exports.getFollowLookInfo = function(reqbody, callback){
    var sql = 'select b.*, c.user_name, c.user_facethumbnail, d.stock_name from user_follow_base_info a, stock_look_info b, user_base_info c, stock_base_info d' +
    ' where a.user_id = ? and a.followed_user_id = b.user_id ' +
    ' and a.followed_user_id = c.user_id ' +
    ' and b.look_status = 1 ' +
    ' and b.stock_code = d.stock_code and b.look_timestamp<? order by b.look_timestamp desc limit 10';
    conn.executeSql(sql, [reqbody.user_id, reqbody.look_timestamp], callback);

}

exports.getLookInfoByUser = function(user_id, look_status, callback){
    var sql = 'select a.*, b.*, c.user_facethumbnail, c.user_look_yield, c.user_name from stock_look_info a, stock_base_info b, user_base_info c ' +
    ' where a.user_id = ?  and c.user_id = a.user_id and a.look_status = ? and a.stock_code = b.stock_code order by look_timestamp desc';
    conn.executeSql(sql, [user_id, look_status], callback);
}

exports.updateLookYield = function(stock_code, price, callback){
    var look_update_timestamp = Date.now();
    var sql = 'update stock_look_info ' +
    ' set stock_yield = look_direct*100*(? - look_stock_price)/look_stock_price, ' +
    ' look_cur_price = ? ' +
    ' look_update_timestamp = ?'
    ' where stock_code = ? and look_status = 1';
    conn.executeSql(sql, [price, price, look_update_timestamp, stock_code], callback);
}

exports.getStockInfo = function(reqbody, callback){
	var sql = "select a.stock_code, a.stock_name, b.price, b.fluctuate, b.date, b.time from stock_base_info a, stock_now_info b where a.stock_code = ? " +
    " and a.stock_code = b.stock_code order by timestamp desc limit 1";
	conn.executeSql(sql, [reqbody.stock_code], callback);
}
