//
//  RankModel.h
//  stockFront
//
//  Created by wang jam on 2/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface RankModel : NSObject

@property NSString* user_id;
@property NSString* user_name;
@property NSString* user_facethumbnail;
@property NSMutableArray* stocklist;
@property NSInteger look_duration;
@property CGFloat total_yield;

@end
