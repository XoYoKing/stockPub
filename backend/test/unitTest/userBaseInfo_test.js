var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/userBaseInfo',
    user_id: '11111'
};

describe('userBaseInfo', function(){
    it('userBaseInfo', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            //console.log(JSON.stringify(body));
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    })
});
