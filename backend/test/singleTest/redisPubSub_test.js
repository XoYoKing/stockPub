var redis = require("redis"),
client = redis.createClient({auth_pass:'here_dev'});

client.on("error", function (err) {
    console.log("Error " + err);
});

var pub = redis.createClient({auth_pass:'here_dev'});
pub.on('error', function(err){
    console.log("Error " + err);
})

//对发布消息的响应
client.on('message', function(channel, message){
    console.log("sub channel " + channel + ": " + message);
});

//对自身订阅后的响应
client.on("subscribe", function (channel, count) {
    console.log("sub channel " + channel + ": " + count);
    pub.publish("first", "I am sending a message."); //向频道first发布信息
});

client.on('reconnecting', function(err, data){
    console.log('reconnecting');
});

client.subscribe("first");
