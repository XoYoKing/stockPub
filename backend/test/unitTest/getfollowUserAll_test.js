var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/getfollowUserAll',
    user_id: 'c186c03ba298bc3cc20490684010a353'
};

describe('getfollowUserAll', function(){
    it('getfollowUserAll', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            //console.log(JSON.stringify(body));
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    })
});
