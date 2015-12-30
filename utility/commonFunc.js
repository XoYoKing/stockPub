var logger = global.logger;
var config = require('../config');
var http = require('http');


exports.getStockInfoFromAPI = function(stock_code, callback) {
	var stockAPI = config.stockDataInterface.url + stock_code;
	logger.debug(stockAPI);

	http.get(stockAPI, function(res) {
		if (res.statusCode == 200) {
			var htmlData = "";
			res.on('data', function(data) {
				htmlData += data;
			});

			res.on('end', function() {
				callback(true, htmlData);
			});
		}
	}).on('error', function(e) {
		logger.error("Got error: " + e.message);
        callback(false, e.message);
	});
}
