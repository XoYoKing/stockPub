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

@property NSString* user_id;
@property NSString* user_facethumbnail;
@property CGFloat user_look_yield;
@property NSString* user_name;
@property NSString* stock_code;
@property NSString* stock_name;
@property CGFloat look_stock_price;
@property NSInteger look_timestamp;
@property CGFloat stock_yield;
@property NSInteger look_status;
@property NSInteger look_finish_timestamp;
@property CGFloat look_cur_price;
@property NSInteger look_update_timestamp;
@property NSInteger look_cur_price_timestamp;
@property NSString* look_id;
@property NSInteger comment_count;

@end
