var should = require('should');
var constant = require('../../utility/constant.js');

var Json = {
    childpath: '/user/register',
    user_phone: '18516053712',
    user_certificate_code: '1808'
};

var runner = require('./unitTestRunner.js');
runner.runTest(Json, Json.childpath, function(err, body){
    should.not.exist(err);
    body.code.should.be.equalOneOf(constant.returnCode.CERTIFICATE_CODE_NOT_MATCH,
        constant.returnCode.REGISTER_SUCCESS, constant.returnCode.PHONE_EXIST);
});
