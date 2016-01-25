var logger = global.logger;
var userOperation = require('../databaseOperation/userOperation');
var stockOperation = require('../databaseOperation/stockOperation');


exports.caculateAllUserYield = function(){
    userOperation.updateAllUserTotalYield(function(flag, result){
        if(flag){
            if(logger == null){
                console.log('success updateAllUserTotalYield');
            }else{
                logger.info('success updateAllUserTotalYield', logger.getFileNameAndLineNum(__filename));
            }
        }else{
            if(logger == null){
                console.log(result);
            }else{
                logger.error(result, logger.getFileNameAndLineNum(__filename));
            }
        }
    });
}
