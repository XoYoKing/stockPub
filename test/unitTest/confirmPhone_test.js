var should = require('should');
var constant = require('../../utility/constant.js');

var Json = {
    childpath: '/user/confirmPhone',
    user_phone: '18516053712',
};

var runner = require('./unitTestRunner.js');
runner.runTest(Json, Json.childpath, function(err, body){
    should.not.exist(err);
    body.code.should.be.equalOneOf(constant.returnCode.CERTIFICATE_CODE_SEND,
        constant.returnCode.CERTIFICATE_CODE_SENDED, constant.returnCode.PHONE_EXIST);
});
