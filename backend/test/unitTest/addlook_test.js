var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/addlook',
    user_id: '66666666',
    user_name: 'wanghan',
    stock_code: '60001',
    look_direct: 1,
    look_stock_price: 20
};

describe('addlook', function(){
    it('addlook', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.LOOK_STOCK_EXIST,
                constant.returnCode.SUCCESS);
            done();
        });
    });
});
