var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/getRankUser',
    look_duration: 7
};

describe('getRankUser', function(){
    it('getRankUser', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    });
});
