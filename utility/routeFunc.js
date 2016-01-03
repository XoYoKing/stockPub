var log = global.logger;


exports.feedBack = function(code, result, res, sq) {
	var returnData = {};
	returnData.code = code;
	returnData.data = result;
	res.send(returnData);
};
