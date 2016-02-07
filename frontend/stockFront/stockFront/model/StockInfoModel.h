//
//  StockInfoModel.h
//  stockFront
//
//  Created by wang jam on 1/12/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockInfoModel : UITableViewController

@property NSString* stock_code;
@property NSString* stock_name;
@property CGFloat price;
@property CGFloat fluctuate;
@property CGFloat fluctuate_value;
@property NSString* date;
@property NSString* time;

@end
