var redis = require("redis"),
client = redis.createClient();
client.on("error", function (err) {
    console.log("Error " + err);
});

client.on('message', function(channel, message){
    console.log("sub channel " + channel + ": " + message);
});


client.on("subscribe", function (channel, count) {
    console.log("sub channel " + channel + ": " + count);
});


client.subscribe("first");
