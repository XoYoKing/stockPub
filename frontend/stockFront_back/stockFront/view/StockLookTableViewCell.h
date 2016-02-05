//
//  StockLookTableViewCell.h
//  stockFront
//
//  Created by wang jam on 1/23/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockLookInfoModel.h"

@interface StockLookTableViewCell : UITableViewCell

- (void)configureCell:(StockLookInfoModel*)stockLookInfoModel;

+ (CGFloat)cellHeight;

@end
