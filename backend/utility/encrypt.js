var crypto = require('crypto');

exports.sha1Cryp = function (str) {
	var shasum = crypto.createHash('sha1');
	shasum.update(str);
	return shasum.digest('hex');
};
