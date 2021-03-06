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

    var sql = 'update stock_look_info set look_finish_timestamp = ?, look_update_timestamp = ?,  look_finish_time = NOW(), look_status = 2  ' +
    ' where user_id = ? and stock_code = ? and look_status = 1';

    conn.executeSql(sql, [look_finish_timestamp, look_finish_timestamp, reqbody.user_id, reqbody.stock_code], callback);
}

exports.getFollowLookInfo = function(reqbody, callback){
    var sql = 'select b.*, c.user_name, c.user_facethumbnail, c.user_look_yield, ' +
    ' d.stock_name from user_follow_base_info a, stock_look_info b, user_base_info c, stock_base_info d' +
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
	var sql = "select a.stock_code, a.stock_name, b.* from stock_base_info a, stock_now_info b where a.stock_code = ? " +
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
            ' `market_index_date`,' +
            ' market_index_trade_amount, `timestamp_ms`)' +
            ' values(?,?,?,?,?,?,?,?,?,?,?,?,?)';

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
        element.market_index_date,
        element.market_index_trade_amount,
        timestamp
    ];
    conn.executeSql(sql, parm, callback);
}


exports.insertMarketIndexNow = function(element, callback){
    var timestamp = Date.now();
    console.log(element.market_index_trade_amount);

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
            ' `market_index_date`,' +
            ' market_index_trade_amount, '+
            ' timestamp_ms, ' +
            ' market_index_time ' +
            ')' +
            ' values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)';

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
        element.market_index_date,
        element.market_index_trade_amount,
        timestamp,
        element.market_index_time
    ];
    conn.executeSql(sql, parm, callback);
}


exports.emptyMarketNowInfo = function(callback){
    var sql = 'delete from market_index_now_info';
    conn.executeSql(sql, [], callback);
}

exports.getMarketIndexNow = function(market_code, callback){
    var sql = 'select* from market_index_now_info where market_code = ? order by timestamp_ms desc limit 1';
    conn.executeSql(sql, [market_code], callback);
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


//获取大盘平均成交额
exports.getMarketAvgVolume = function(stock_code, day, callback){
    var sql = 'SELECT `market_index_trade_volume`  FROM `market_index_day_info` ' +
    ' WHERE `market_code`  = ? ORDER BY `market_index_date` desc LIMIT '+day;
    conn.executeSql(sql, [stock_code], callback);
}

//获取股票平均成交额
exports.getAvgVolume = function(stock_code, day, callback){
    var sql = 'SELECT `volume`  FROM `stock_amount_info` ' +
    ' WHERE `stock_code`  = ? ORDER BY `date` desc LIMIT '+day;
    conn.executeSql(sql, [stock_code], callback);
}


//获取股票股价
exports.getStockDayInfo = function(stock_code, num_day, callback){
    var sql = 'select x.stock_name, t.*, t.5day_av_price as fiveday_av_price, ' +
    ' t.10day_av_price as tenday_av_price, t.20day_av_price as twentyday_av_price from ('+
    ' SELECT a.*  FROM `stock_amount_info` a ' +
    ' WHERE a.`stock_code` = ? ORDER BY a.`date` DESC LIMIT '+num_day+') t, stock_base_info x where t.stock_code = x.stock_code '+
    ' ORDER BY t.timestamp_ms asc';
    conn.executeSql(sql, [stock_code], callback);
}

//获取大盘每日信息
exports.getMarketDayInfo = function(market_code, num_day, callback){
    var sql = 'select t.* ' +
    'from ('+
    ' SELECT a.*  FROM `market_index_day_info` a ' +
    ' WHERE a.`market_code` = ? ORDER BY a.`market_index_date` DESC LIMIT '+num_day+') t'+
    ' ORDER BY t.timestamp_ms asc';
    conn.executeSql(sql, [market_code], callback);
}

exports.getStockDayInfoLessNowDay = function(stock_code, num_day, nowDay, callback){
    var sql = 'select t.* from ('+
    ' SELECT a.*  FROM `stock_amount_info` a ' +
    ' WHERE a.`stock_code` = ? and a.date <= ? ORDER BY a.`date` DESC LIMIT '+num_day+') t'+
    ' ORDER BY t.timestamp_ms asc';
    conn.executeSql(sql, [stock_code, nowDay], callback);
}

exports.getMarketDayInfoLessNowDay = function(market_code, num_day, nowDay, callback){
    var sql = 'select t.* from ('+
    ' SELECT a.*  FROM `market_index_day_info` a ' +
    ' WHERE a.`market_code` = ? and a.market_index_date <= ? ORDER BY a.`market_index_date` DESC LIMIT '+num_day+') t'+
    ' ORDER BY t.timestamp_ms asc';
    conn.executeSql(sql, [market_code, nowDay], callback);
}

exports.getAllStockCode = function(callback){
	var sql = "select stock_code from stock_base_info";
	conn.executeSql(sql, [], callback);
}

exports.getAllMarketCode = function(callback){
    var sql = "select market_code from market_index_base_info";
	conn.executeSql(sql, [], callback);
}

exports.updateMarket5AvPrice = function(stockCode, av_price, date, callback){
	var sql = "update market_index_day_info set market_index_five_av_value = ? where market_code = ? and market_index_date = ?";
	conn.executeSql(sql, [av_price, stockCode, date], callback);
}

exports.updateMarket10AvPrice = function(stockCode, av_price, date, callback){
    var sql = "update market_index_day_info set market_index_ten_av_value = ? where market_code = ? and market_index_date = ?";
	conn.executeSql(sql, [av_price, stockCode, date], callback);
}

exports.updateMarket20AvPrice = function(stockCode, av_price, date, callback){
    var sql = "update market_index_day_info set market_index_twenty_av_value = ? where market_code = ? and market_index_date = ?";
	conn.executeSql(sql, [av_price, stockCode, date], callback);
}

exports.update5AvPrice = function(stockCode, av_price, date, callback){
	var sql = "update stock_amount_info set 5day_av_price = ? where stock_code = ? and date = ?";
	conn.executeSql(sql, [av_price, stockCode, date], callback);
}

exports.update10AvPrice = function(stockCode, av_price, date, callback){
	var sql = "update stock_amount_info set 10day_av_price = ? where stock_code = ? and date = ?";
	conn.executeSql(sql, [av_price, stockCode, date], callback);
}

exports.update20AvPrice = function(stockCode, av_price, date, callback){
	var sql = "update stock_amount_info set 20day_av_price = ? where stock_code = ? and date = ?";
	conn.executeSql(sql, [av_price, stockCode, date], callback);
}




exports.getDate = function(callback){
    var sql = 'SELECT date FROM `stock_amount_info` GROUP BY `date` ORDER BY `date` DESC ';
    conn.executeSql(sql, [], callback);
}


exports.getStockBaseInfoByCode = function(stock_code, callback){
    var sql = 'select *from stock_base_info where stock_code = ?';
    conn.executeSql(sql, [stock_code], callback);
}


exports.getAllStockInfo = function(callback){
    var sql = 'select *from stock_base_info';
    conn.executeSql(sql, [], callback);
}

exports.updateStockAlpha = function(stock_code, stock_alpha_info, callback){
    var sql = 'update stock_base_info set stock_alpha_info = ? where stock_code = ?';
    conn.executeSql(sql, [stock_alpha_info, stock_code], callback);
}

exports.updateStockName = function(stock_code, stock_name, stock_alpha_info, callback){
    var sql = 'update stock_base_info set stock_alpha_info = ?, stock_name = ? where stock_code = ?';
    conn.executeSql(sql, [stock_alpha_info, stock_name, stock_code], callback);
}


exports.getStockBaseInfoByAlpha = function(stock_alpha_info, callback){
    var sql = 'select *from stock_base_info where stock_alpha_info like \'%'+stock_alpha_info+'%\' limit 8';
    conn.executeSql(sql, [], callback);
}


exports.getAllMarketIndexDay = function(callback){
    var sql = 'select *from market_index_day_info';
    conn.executeSql(sql, [], callback);
}
