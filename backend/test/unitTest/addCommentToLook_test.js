var should = require('should');
var constant = require('../../utility/constant.js');
var runner = require('./unitTestRunner.js');

var Json = {
    childpath: '/user/addCommentToLook',
    look_id: '123',
    comment_user_id: '22233',
    comment_to_user_id: '111123',
    comment_content: '1122333',
    to_look: 1,
    comment_user_name:'111233'
};

describe('addCommentToLook', function(){
    it('addCommentToLook', function(done){
        runner.runTest(Json, Json.childpath, function(err, body){
            should.not.exist(err);
            body.code.should.be.equal(constant.returnCode.SUCCESS);
            done();
        });
    });
});
