var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var followUserJson = {
    childpath: '/stock/getAllMarketIndexNow'
};

describe('getAllMarketIndexNow', function(){
    it('getAllMarketIndexNow', function(done){
        runner.runTest(followUserJson, followUserJson.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(
                constant.returnCode.SUCCESS);
            done();
        });
    })
});
