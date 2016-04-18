var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/addstock',
    user_id: '11111',
    stock_code: '300027'
};

describe('addstock', function(){
    it('addstock', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            //console.log(JSON.stringify(body));
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    })
});
