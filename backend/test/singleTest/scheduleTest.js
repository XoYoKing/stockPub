var schedule = require('node-schedule');

console.log('enter schedule');
schedule.scheduleJob('*/42 * * * * *', function(){
  console.log('The answer to life, the universe, and everything!');
});

const schedule1 = require('node-schedule');

console.log('next');
schedule1.scheduleJob('*/20 * * * * *', function(){
  console.log('The world is going to end today.');
});





process.on('uncaughtException', function(err) {
    console.log('schedule process Caught exception: ' +
        err.stack);

   // email.sendMail('Caught exception: ' + err.stack,
   // 			'stockSchedule process failed');
});
