var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/getAllMarketIndexNowByCode',
    stock_code: 'sh000001'
};

describe('getAllMarketIndexNowByCode', function(){
    it('getAllMarketIndexNowByCode', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(
                constant.returnCode.SUCCESS);
            done();
        });
    })
});
