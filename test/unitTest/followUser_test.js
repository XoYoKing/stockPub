var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var followUserJson = {
    childpath: '/user/followUser',
    user_id: 'c186c03ba298bc3cc20490684010a353',
    user_name: 'jam',
    followed_user_id: '7c497868c9e6d3e4cf2e87396372cd3b'
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
