var should = require('should');
var constant = require('../../utility/constant.js');

var Json = {
    childpath: '/user/login',
    user_phone: '18516053712',
    user_password: '12345'
};

var runner = require('./unitTestRunner.js');
runner.runTest(Json, Json.childpath, function(err, body){
    should.not.exist(err);
    body.code.should.be.equalOneOf(constant.returnCode.LOGIN_SUCCESS,
        constant.returnCode.LOGIN_FAIL);
});
