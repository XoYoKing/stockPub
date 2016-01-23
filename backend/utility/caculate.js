var logger = global.logger;
var userOperation = require('../databaseOperation/userOperation');
var stockOperation = require('../databaseOperation/stockOperation');


exports.caculateAllUserYield = function(){
    userOperation.updateAllUserTotalYield(function(flag, result){
        if(flag){
            logger.info('success updateAllUserTotalYield', logger.getFileNameAndLineNum(__filename));
        }else{
            logger.error(result, logger.getFileNameAndLineNum(__filename));
        }
    });
}
