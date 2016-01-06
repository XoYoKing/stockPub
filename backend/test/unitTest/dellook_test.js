var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/dellook',
    user_id: '66666666',
    stock_code: '60001',
    stock_name: 'wwww'
};

describe('dellook', function(){
    it('dellook', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.SUCCESS);
            done();
        });
    });
});
