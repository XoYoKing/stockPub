var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/getFollowLookInfo',
    user_id: 'cbd41c6103064d3f0af848208c20ece2',
    look_timestamp:  Date.now()
};

describe('getFollowLookInfo', function(){
    it('getFollowLookInfo', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    });
});
