var crypto = require('crypto');

exports.sha1Cryp = function (str) {
	var shasum = crypto.createHash('sha1');
	shasum.update(str);
	return shasum.digest('hex');
};


exports.encodeBase64 = function (str) {
	var encodeStr = new Buffer(str);
	encodeStr = encodeStr.toString('base64');
	return encodeStr;
};

exports.decodeBase64 = function (str) {
	var decodeStr = new Buffer(str, 'base64');
	decodeStr = decodeStr.toString();
	return decodeStr;
};
