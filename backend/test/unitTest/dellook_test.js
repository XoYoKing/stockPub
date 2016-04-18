var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/stock/dellook',
    user_id: 'c186c03ba298bc3cc20490684010a',
    user_name: 'jam',
    stock_code: '002496',
    stock_name: 'wwww'
};

describe('dellook', function(){
    it('dellook', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equalOneOf(constant.returnCode.SUCCESS,
                constant.returnCode.LOOK_DEL_NOT_TODAY);
            done();
        });
    });
});
