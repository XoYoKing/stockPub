//
//  MarketIndexDetailCell.h
//  stockFront
//
//  Created by wang jam on 2/7/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockInfoModel.h"


@interface MarketIndexDetailCell : UITableViewCell

- (void)configureCell:(StockInfoModel*)model;

+ (CGFloat)cellHeight;


@end
