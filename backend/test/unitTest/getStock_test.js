var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/getStock',
    stock_code: '300492'
};

describe('getStock', function(){
    it('getStock', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.STOCK_NOT_EXIST,
                constant.returnCode.SUCCESS);
            done();
        });
    });
});
