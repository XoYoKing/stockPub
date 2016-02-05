//
//  LocDatabase.h
//  CarSocial
//
//  Created by wang jam on 9/26/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockInfoModel.h"
#import "MyStock.h"
#import "LookStock.h"
#import "UserInfoModel.h"
#import "FollowUser.h"

@interface LocDatabase : NSObject




- (BOOL)connectToDatabase:(NSString*)fileName;

- (BOOL)addFollow:(UserInfoModel*)userModel;

- (BOOL)delFollow:(UserInfoModel*)userModel;

- (BOOL)isFollow:(UserInfoModel*)userModel;

- (BOOL)addStock:(StockInfoModel*)model;

- (BOOL)deleteStock:(StockInfoModel*)model;

- (NSMutableArray*)getStocklist;

- (BOOL)addLookStock:(StockInfoModel*)model;

- (BOOL)deleteLookStock:(StockInfoModel*)model;

- (BOOL)isLookStock:(StockInfoModel*)model;

@end
