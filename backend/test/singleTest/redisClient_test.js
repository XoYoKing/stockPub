var redis = require("redis");
var redisClient = redis.createClient({auth_pass:'here_dev'});
redisClient.on("error", function (err) {
    console.log(err);
});

setInterval(function(){
    redisClient.get('test1', function(err, reply){
        if (err) {
            console.log(err);
        }else{
            console.log('key:test1 value:'+reply);
        }
    });
}, 1000);
setInterval(function(){
    redisClient.get('test2', function(err, reply){
        if(err){
            console.log(err);
        }else{
            console.log('key:test2 value:'+reply);
        }
    });
}, 1000);
setInterval(function(){
    redisClient.get('test3', function(err, reply){
        if (err) {
            console.log(err);
        }else{
            console.log('key:test3 value:'+reply);
        }
    });
}, 1000);
