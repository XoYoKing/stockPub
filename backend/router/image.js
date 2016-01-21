var express = require('express');
var log = global.log;
var config = require('../config');
var fs = require('fs');
var router = express.Router();
var path = require('path');

router.get('/', function (req, res) {
	var filePath = path.join(process.env.HOME, config.stockPubFaceDir.dir, req.query.name);
	log.debug(filePath, log.getFileNameAndLineNum(__filename));
	fs.exists(filePath, function (exists) {
		if (exists) {
			res.sendFile(filePath);
		}else {
			log.error(filePath + ' not exists', log.getFileNameAndLineNum(__filename));
		}
	});
});

module.exports = router;
