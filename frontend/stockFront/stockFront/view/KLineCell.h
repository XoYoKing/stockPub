//
//  KLineCell.h
//  stockFront
//
//  Created by wang jam on 2/17/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockInfoModel.h"

@interface KLineCell : UITableViewCell

- (void)configureCell:(StockInfoModel*)model;

+ (NSInteger)cellHeight;

@end
