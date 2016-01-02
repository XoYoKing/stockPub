var Json = {
    childpath: '/user/confirmPhone',
    user_phone: '18516053712',
};

var runner = require('./unitTestRunner.js');
runner.runTest(Json, Json.childpath);
