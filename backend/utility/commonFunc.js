var logger = global.logger;
var config = require('../config');
var http = require('http');
var gs = require('nodegrass');


exports.analyzeMarketMessage = function(htmlData, market_code){

    var beginIndex = htmlData.indexOf("\"");
    var endIndex = htmlData.lastIndexOf("\"");
    var element = {};

    if (beginIndex !== -1 && endIndex !== -1) {
        var data = htmlData.substr(beginIndex + 1, endIndex - beginIndex - 1);
        if (data !== null) {
            var dataArr = data.split("~");
            if(dataArr.length<48){
                logger.warn('elementArr is empty');
                return;
            }
            var date = dataArr[30];
            date = date.substr(0, 4)+"-"+date.substr(4, 2)+"-"+date.substr(6, 2);
            element.market_code = market_code;
            element.market_name = dataArr[1];
            element.market_index_date = date;

            var time = dataArr[30];
            time = time.substr(8, 2)+":"+time.substr(10, 2)+":"+time.substr(12, 2);
            element.market_index_time = time;

            element.market_index_value_now   = dataArr[3];
            element.market_index_fluctuate = dataArr[32];
            element.market_index_fluctuate_value = dataArr[31];
            element.market_index_trade_volume = dataArr[37];
            element.market_index_value_high = dataArr[33];
            element.market_index_value_low = dataArr[34];
            element.market_index_value_open = dataArr[5];
            element.market_index_value_yesterday_close = dataArr[4];
            element.market_index_trade_amount = dataArr[36];

            if (element.market_code === undefined ||
                element.market_index_trade_volume === undefined ||
                element.market_index_date === undefined ||
                element.market_index_value_now === undefined ||
                element.market_index_value_open === undefined) {
                    //logger.warn('stockCode is undefined');
                return null;
            }
        }else{
            return null
        }
    }else{
        return null;
    }

    return element;
}

exports.analyzeMessage = function(htmlData){

    var elementArr = htmlData.split(";");
	if (elementArr.length === 0) {
		logger.warn('elementArr is empty');
		return false;
	}

    var stockInfoArr = [];
	elementArr.forEach(function(elementStr){
		var beginIndex = elementStr.indexOf("\"");
		var endIndex = elementStr.lastIndexOf("\"");
		if (beginIndex !== -1 && endIndex !== -1) {
			var data = elementStr.substr(beginIndex + 1, endIndex - beginIndex - 1);
			if (data !== null) {
				var dataArr = data.split("~");
				if(dataArr.length<48){
					logger.warn('elementArr is empty');
					return;
				}

                var element = {};
                element.stock_name = dataArr[1];
				element.stock_code = dataArr[2];
				element.amount = parseInt(dataArr[6]);
				var date = dataArr[30];
				element.date = date.substr(0, 4)+"-"+date.substr(4, 2)+"-"+date.substr(6, 2);
				var time = dataArr[30];
				element.time = time.substr(8, 2)+":"+time.substr(10, 2)+":"+time.substr(12, 2);

                element.price = parseFloat(dataArr[3]);
				element.fluctuate = parseFloat(dataArr[32]);
                element.fluctuate_value = parseFloat(dataArr[31]);
				element.priceearning = parseFloat(dataArr[39]);
				element.marketValue = parseFloat(dataArr[45]);
				element.pb = parseFloat(dataArr[46]);
				element.flowMarketValue = parseFloat(dataArr[44]);
				element.volume = parseFloat(dataArr[37]);
				element.openPrice = parseFloat(dataArr[5]);
				element.high_price = parseFloat(dataArr[33]);
				element.low_price = parseFloat(dataArr[34]);
                element.market = getMarketDesc(element.stock_code);

				if (element.stock_code === undefined ||
					element.amount === undefined ||
					element.date === undefined ||
					element.time === undefined ||
					element.price === undefined ||
					element.openPrice === undefined||
					element.amount === 0||
					element.price === 0.00) {
						//logger.warn('stockCode is undefined');
					return;
				}
                stockInfoArr.push(element);
			}
		}
	});

    return stockInfoArr;
};


exports.getStockInfoFromAPI = function(stock_code, callback) {

    var mrkDesc = getMarketDesc(stock_code);
	var stockAPI = config.stockDataInterface.url + mrkDesc + stock_code;
	logger.debug(stockAPI);

	gs.get(stockAPI, function(data, status, headers) {
        if(status === 200){
            callback(true, data);
        }else{
            callback(false, data);
        }

        // console.log(headers);
        // console.log(status);
        // console.log(data);

	}, null, 'gbk').on('error', function(e) {
		logger.error("Got error: " + e.message);
        callback(false, e.message);
	});
}



function getMarketDesc(stock_code) {
	if (stock_code.indexOf("3") === 0 || stock_code.indexOf("0") === 0) {
		return "sz";
	}
	if (stock_code.indexOf("6") === 0) {
		return "sh";
	}
	return "";
}
