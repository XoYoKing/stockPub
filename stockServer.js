var path = require('path');

var log = require('./utility/log');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockHandle_'));
global.logger = log; // 设置全局

var express = require('express');
var bodyParser = require('body-parser');
var cluster = require('cluster');
var port = 80;
var stockHandle = require('./stockHandle');
var stockCrawl = require('./stockCrawl');

var restartCount = 3;


if (cluster.isMaster) {
	cluster.fork();

	cluster.on('exit', function(worker, code, signal) {
		if (restartCount>0) {
			logger.debug('worker process ' + worker.process.pid + ' died');
    		cluster.fork();
    		--restartCount;
		}else{
			logger.error('master process exit for worker exception');
			process.exit();
		}
  	});

	cluster.on('listening', function(worker, address) {
		logger.debug("A server worker with pid#"+worker.process.pid+" is now listening to:" + address.port);
 	});


}else{

	process.on('uncaughtException', function (err) {
		logger.error('worker exception: ' + err.stack);
		//process.exit();
	});

	global.app = express();//创建express实例

	// view engine setup
	global.app.set('views', path.join(__dirname, 'views'));
	global.app.set('view engine', 'ejs');
	global.app.set('imagePath', path.join(__dirname, 'images'));


	global.app.use(bodyParser.json());
	global.app.use(bodyParser.urlencoded({ extended: false }));

	global.app.use(express.static(__dirname + '/css'));
	global.app.use(express.static(__dirname + '/js'));
	global.app.use(express.static(__dirname + '/images'));

	global.app.use('/', stockHandle);
	global.app.listen(port);//设置监听http请求的端口号
	logger.info("Express started on port "+port);
}
