var express = require('express');
var router = express.Router();
var logger = global.logger;

module.exports = router;


router.get('/test', function(req, res) {
	logger.debug('get test');
	res.send('stock test');
});
