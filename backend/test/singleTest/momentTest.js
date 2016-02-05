var moment = require('moment');
var timestamp = Date.now();
console.log(moment(timestamp).format('YYYY-MM-DD'));

console.log(moment().format('MMMM Do YYYY, h:mm:ss a'));
