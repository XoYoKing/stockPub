var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/getCommentToStockByUser',
    user_id: '300027',
    talk_timestamp_ms: Date.now()
};


//
describe('getCommentToStockByUser', function(){
    it('getCommentToStockByUser', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    });
});
