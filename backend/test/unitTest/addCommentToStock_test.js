var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/addCommentToStock',
    talk_stock_code: '300027',
    talk_user_id: '11223344',
    user_name: 'jam',
    talk_content: '我很看好这只股票',
    to_stock: 1
};


//
describe('addCommentToStock', function(){
    it('addCommentToStock', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    });
});
