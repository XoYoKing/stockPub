//
//  StockActionTableViewCell.h
//  stockFront
//
//  Created by wang jam on 1/21/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockInfoModel.h"

@interface StockActionTableViewCell : UITableViewCell

- (void)configureCell:(StockInfoModel*)stockInfoModel;

+ (CGFloat)cellHeight;

@end
