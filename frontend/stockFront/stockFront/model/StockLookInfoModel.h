//
//  StockLookInfoModel.h
//  stockFront
//
//  Created by wang jam on 1/15/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockInfoModel.h"

@interface StockLookInfoModel : NSObject

@property NSString* stock_code;
@property NSString* stock_name;
@property CGFloat look_stock_price;
@property NSInteger look_timestamp;
@property CGFloat stock_yield;
@property NSInteger look_status;
@property NSInteger look_finish_timestamp;

@end
