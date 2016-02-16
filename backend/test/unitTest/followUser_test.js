var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var followUserJson = {
    childpath: '/user/followUser',
    user_id: 'cbd41c6103064d3f0af848208c20ece2',
    user_name: 'jam',
    followed_user_id: 'c186c03ba298bc3cc20490684010a353'
};

describe('followUser', function(){
    it('followUser', function(done){
        runner.runTest(followUserJson, followUserJson.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.FOLLOW_USER_EXIST,
                constant.returnCode.SUCCESS);
            done();
        });
    })
});
