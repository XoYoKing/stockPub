var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/register',
    user_phone: '66666666',
    user_name: 'jam1024',
    user_password: '123456',
    user_certificate_code: '4205'
};

describe('register', function(){
    it('register', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.CERTIFICATE_CODE_NOT_MATCH,
                constant.returnCode.REGISTER_SUCCESS, constant.returnCode.PHONE_EXIST);
            done();
        });
    });
});
