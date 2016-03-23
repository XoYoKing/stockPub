//
//  getCommentToStockAction.h
//  stockFront
//
//  Created by wang jam on 3/16/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"
@interface getCommentToStockAction : NSObject<pullAction>

- (id)initWithStockCode:(NSString*)stock_code;


@end
