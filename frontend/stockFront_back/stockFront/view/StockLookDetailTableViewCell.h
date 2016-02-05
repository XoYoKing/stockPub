//
//  StockLookDetailTableViewCell.h
//  stockFront
//
//  Created by wang jam on 1/24/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockLookInfoModel.h"

@interface StockLookDetailTableViewCell : UITableViewCell

- (void)configureCell:(StockLookInfoModel*)stockLookInfoModel;

+ (CGFloat)cellHeight;


@end
