var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/addlook',
    user_id: 'c186c03ba298bc3cc20490684010a',
    user_name: 'jam112',
    stock_code: '002496',
    stock_name: 'xxxxx',
    look_direct: 1
};

describe('addlook', function(){
    it('addlook', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.LOOK_STOCK_EXIST,
                constant.returnCode.SUCCESS, constant.returnCode.STOCK_NOT_EXIST, constant.returnCode.LOOK_STOCK_COUNT_OVER);
            done();
        });
    });
});
