var log = global.logger;
var constant = require('constant.js');


exports.feedBack = function(code, result, res, sq) {
	var returnData = {};
	returnData.code = code;
	returnData.data = result;
	res.send(returnData);
};
