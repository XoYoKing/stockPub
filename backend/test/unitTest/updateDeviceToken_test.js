var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/updateDeviceToken',
    user_id: 'c186c03ba298bc3cc20490684010a353',
    device_token: 'testdevice_token'
};

describe('updateDeviceToken', function(){
    it('updateDeviceToken', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    });
});
