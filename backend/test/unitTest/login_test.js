require('mocha');

var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/login',
    user_phone: '18516053712',
    user_password: '123456'
};

describe('login', function(){
    it("login", function(done) {
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.LOGIN_SUCCESS,
                constant.returnCode.LOGIN_FAIL);
                done();
        });
    });
});
