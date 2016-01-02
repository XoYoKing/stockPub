var path = require('path');
var log = require('./log.js');
log.SetLogFileName(path.join(process.env.HOME, 'stocklogs/stockServer_'));
global.logger = log; // 设置全局

var express = require('express');
var bodyParser = require('body-parser');
var cluster = require('cluster');
var email = require('./utility/emailTool');
var stockRouter = require('./router/stockRouter.js');
var userRouter = require('./router/userRouter.js');
var config = require('./config');
var port = config.stockServerInfo.port;
var morgan = require('morgan');
var fileStreamRotator = require('file-stream-rotator');


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

// create a rotating write stream
var accessLogStream = fileStreamRotator.getStream({
    filename: path.join(process.env.HOME,
        'stocklogs', '/stockServer_access_%DATE%.log'),
    frequency: 'daily',
    verbose: false,
    date_format: "YYYY-MM-DD"
});

global.app.use(morgan('short', {
    stream: accessLogStream
}));

// 该路由使用的中间件
global.app.use(function(req, res, next) {
    req.body.sq = Date.now();
    log.info(JSON.stringify(req.body), log.getFileNameAndLineNum(
            __filename),
        req.body.sq);
    next();
});


global.app.use('/stock', stockRouter);
global.app.use('/user', userRouter);

global.app.listen(port); //设置监听http请求的端口号
logger.info("stockServer started on port " + port);
