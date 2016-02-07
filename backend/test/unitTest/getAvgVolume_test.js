var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var followUserJson = {
    childpath: '/stock/getAvgVolume',
    stock_code: '000001',
    day: 5
};

describe('getAvgVolume', function(){
    it('getAvgVolume', function(done){
        runner.runTest(followUserJson, followUserJson.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(
                constant.returnCode.SUCCESS);
            done();
        });
    })
});
