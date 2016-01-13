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

@interface LocDatabase : NSObject




- (BOOL)connectToDatabase:(NSString*)fileName;

- (BOOL)addStock:(StockInfoModel*)model;

- (BOOL)deleteStock:(StockInfoModel*)model;

- (NSMutableArray*)getStocklist;


@end
