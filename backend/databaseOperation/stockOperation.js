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
