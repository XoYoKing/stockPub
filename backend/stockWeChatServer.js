var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockWechatServer_'));
global.logger = log; // 设置全局

var express = require('express');
var bodyParser = require('body-parser');
var cluster = require('cluster');
var port = 80;
var wechatHandle = require('./wechatHandle.js');
var email = require('./utility/emailTool');


process.on('uncaughtException', function(err) {
	log.error('worker exception: ' + err.stack);
	email.sendMail('Caught exception: ' + err.stack,
		'stockWechatServer process failed');
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

global.app.use('/', wechatHandle);
global.app.listen(port); //设置监听http请求的端口号
log.info("stockWechatServer started on port " + port);
