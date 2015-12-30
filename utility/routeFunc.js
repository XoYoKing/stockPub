var log = global.logger;
var constant = require('constant.js');


exports.feedBack = function(flag, result, res, sq) {

	var returnData = {};
	if (flag) {
		returnData.code = constant.returnCode.SUCCESS;
		returnData.data = result;
	} else {
		log.error(result, log.getFileNameAndLineNum(__filename), sq);
		returnData.code = constant.returnCode.ERROR;
		//email.sendMail(result);

	}
	log.debug(JSON.stringify(returnData), log.getFileNameAndLineNum(__filename),
		sq);
	res.send(returnData);
};
