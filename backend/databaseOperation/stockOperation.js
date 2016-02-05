var mysql = require('mysql');
var conn = require('../utility.js');

var logger = global.logger;

exports.addlookStock = function(reqbody, callback){
    var look_timestamp = Date.now();
    var md5 = require('MD5');
    var look_id = md5(reqbody.user_id+reqbody.stock_code+look_timestamp);

    var sql = 'insert into stock_look_info(look_id, user_id, stock_code, look_direct, look_stock_price, look_time, look_timestamp, look_update_timestamp) ' +
    'values(?, ?, ?, ?, ?, NOW(), ?, ?)';
    conn.executeSql(sql, [look_id, reqbody.user_id, reqbody.stock_code,
        reqbody.look_direct, reqbody.look_stock_price, look_timestamp, look_timestamp], callback);
};

exports.dellookStock = function(reqbody, callback){
    var look_finish_timestamp = Date.now();

    sql = 'update stock_look_info set look_finish_timestamp = ?, look_update_timestamp = ?,  look_finish_time = NOW(), look_status = 2  ' +
    ' where user_id = ? and stock_code = ? and look_status = 1';

    conn.executeSql(sql, [look_finish_timestamp, look_finish_timestamp, reqbody.user_id, reqbody.stock_code], callback);
}

exports.getFollowLookInfo = function(reqbody, callback){
    var sql = 'select b.*, c.user_name, c.user_facethumbnail, d.stock_name from user_follow_base_info a, stock_look_info b, user_base_info c, stock_base_info d' +
    ' where a.user_id = ? and a.followed_user_id = b.user_id ' +
    ' and a.followed_user_id = c.user_id ' +
    ' and b.stock_code = d.stock_code and b.look_update_timestamp<? order by b.look_update_timestamp desc limit 10';
    conn.executeSql(sql, [reqbody.user_id, reqbody.look_update_timestamp], callback);

}

exports.getLookInfoByUser = function(user_id, look_status, callback){
    var sql = 'select a.*, b.*, c.user_facethumbnail, c.user_look_yield, c.user_name from stock_look_info a, stock_base_info b, user_base_info c ' +
    ' where a.user_id = ?  and c.user_id = a.user_id and a.look_status = ? and a.stock_code = b.stock_code order by look_update_timestamp desc';
    conn.executeSql(sql, [user_id, look_status], callback);
}

exports.updateLookYield = function(stock_code, price, callback){
    var look_update_timestamp = Date.now();
    var sql = 'update stock_look_info ' +
    ' set stock_yield = look_direct*100*(? - look_stock_price)/look_stock_price, ' +
    ' look_cur_price = ?, ' +
    ' look_cur_price_timestamp = ? ' +
    ' where stock_code = ? and look_status = 1';
    conn.executeSql(sql, [price, price, look_update_timestamp, stock_code], callback);
}

exports.getStockInfo = function(reqbody, callback){
	var sql = "select a.stock_code, a.stock_name, b.price, b.fluctuate, b.date, b.time from stock_base_info a, stock_now_info b where a.stock_code = ? " +
    " and a.stock_code = b.stock_code order by timestamp desc limit 1";
	conn.executeSql(sql, [reqbody.stock_code], callback);
}


exports.getAllMarketIndexInfo = function(callback){
    var sql = 'select *from market_index_base_info';
    conn.executeSql(sql, [], callback);
}

exports.insertMarketIndexDay = function(element, callback){
    var timestamp = Date.now();
    var sql = 'insert into `market_index_day_info` (' +
            ' `market_code`, ' +
            ' `market_index_value_now`,' +
            ' `market_index_fluctuate`,' +
            ' `market_index_fluctuate_value`,' +
            ' `market_index_value_open`,' +
            ' `market_index_value_yesterday_close`,' +
            ' `market_index_trade_volume`,' +
            ' `market_index_value_high`,' +
            ' `market_index_value_low`,' +
            ' `timestamp`, ' +
            ' `market_index_date`)' +
            ' values(?,?,?,?,?,?,?,?,?,?,?)';

    var parm = [
        element.market_code,
        element.market_index_value_now,
        element.market_index_fluctuate,
        element.market_index_fluctuate_value,
        element.market_index_value_open,
        element.market_index_value_yesterday_close,
        element.market_index_trade_volume,
        element.market_index_value_high,
        element.market_index_value_low,
        timestamp,
        element.market_index_date
    ];
    conn.executeSql(sql, parm, callback);
}


exports.insertMarketIndexNow = function(element, callback){
    var timestamp = Date.now();
    var sql = 'insert into `market_index_now_info` (' +
            ' `market_code`, ' +
            ' `market_index_value_now`,' +
            ' `market_index_fluctuate`,' +
            ' `market_index_fluctuate_value`,' +
            ' `market_index_value_open`,' +
            ' `market_index_value_yesterday_close`,' +
            ' `market_index_trade_volume`,' +
            ' `market_index_value_high`,' +
            ' `market_index_value_low`,' +
            ' `timestamp`, ' +
            ' `market_index_date`)' +
            ' values(?,?,?,?,?,?,?,?,?,?,?)';

    var parm = [
        element.market_code,
        element.market_index_value_now,
        element.market_index_fluctuate,
        element.market_index_fluctuate_value,
        element.market_index_value_open,
        element.market_index_value_yesterday_close,
        element.market_index_trade_volume,
        element.market_index_value_high,
        element.market_index_value_low,
        timestamp,
        element.market_index_date
    ];
    conn.executeSql(sql, parm, callback);
}


exports.emptyMarketNowInfo = function(callback){
    var sql = 'delete from market_index_now_info';
    conn.executeSql(sql, [], callback);
}

exports.getAllMarketIndexNow = function(callback){
    var sql = 'SELECT a.*, c.`market_name` FROM `market_index_now_info` a, ' +
    ' (SELECT market_code, MAX(`timestamp`) as timestamp  FROM `market_index_now_info` GROUP BY `market_code`) b, ' +
    ' `market_index_base_info` c' +
    ' WHERE a.`market_code`  =  b.market_code' +
    ' and a.`timestamp` = b.timestamp ' +
    ' and a.`market_code`  = c.`market_code` order by market_code asc';

    conn.executeSql(sql, [], callback);
}

exports.clearStockLookYield = function(callback){
    var sql = 'TRUNCATE `stock_look_yield`';
    conn.executeSql(sql, [], callback);
}

exports.getStockLookInfoByStatus = function(status, callback){
    var sql = 'select *from stock_look_info where look_status = ?';
    conn.executeSql(sql, [status], callback);
}

exports.insertStockLookYield = function(element, callback){
    var update_timestamp = Date.now();
    var sql = 'insert into stock_look_yield(look_id, look_yield, look_duration, update_timestamp, ' +
    'look_cur_price, look_cur_price_date, look_duration_price, look_duration_price_date, look_date, user_id) ' +
    'values(?,?,?,?,?,?,?,?,?,?)';

    conn.executeSql(sql,
        [element.look_id,
        element.look_yield,
        element.look_duration,
        update_timestamp,
        element.look_cur_price,
        element.look_cur_price_date,
        element.look_duration_price,
        element.look_duration_price_date,
        element.look_date,
        element.user_id], callback);
}


exports.getStockDayInfoByDate = function(stock_code, date, callback){
    var sql = 'select* from stock_amount_info where stock_code = ? and date>=? order by date asc limit 1';
    conn.executeSql(sql, [stock_code, date], callback);
}

exports.getUserIdFromLookYield = function(callback){
    var sql = 'select user_id from stock_look_yield group by user_id';
    conn.executeSql(sql, [], callback);
}


exports.getAllStockLook = function(callback){
    var sql = 'select * from stock_look_info';
    conn.executeSql(sql, [], callback);
}
