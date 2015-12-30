var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockServer_'));
global.logger = log; // 设置全局

var express = require('express');
var bodyParser = require('body-parser');
var cluster = require('cluster');
var port = 18000;
var email = require('./utility/emailTool');
var stockRouter = require('./router/stockRouter.js');


process.on('uncaughtException', function(err) {
	logger.error('worker exception: ' + err.stack);
	email.sendMail('Caught exception: ' + err.stack,
		'stockServer process failed');
});

global.app = express(); //创建express实例

// view engine setup
global.app.set('views', path.join(__dirname, 'views'));
global.app.set('view engine', 'ejs');
global.app.set('imagePath', path.join(__dirname, 'images'));


global.app.use(bodyParser.json());
global.app.use(bodyParser.urlencoded({
	extended: false
}));

global.app.use(express.static(__dirname + '/css'));
global.app.use(express.static(__dirname + '/js'));
global.app.use(express.static(__dirname + '/images'));

global.app.use('/stock', stockRouter);

global.app.listen(port); //设置监听http请求的端口号
logger.info("stockServer started on port " + port);
