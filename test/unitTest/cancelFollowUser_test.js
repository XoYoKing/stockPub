var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/cancelFollowUser',
    user_id: '11111',
    followed_user_id: '999999999'
};

describe('cancelFollowUser', function(){
    it('cancelFollowUser', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.SUCCESS);
            done();
        });
    })
});
