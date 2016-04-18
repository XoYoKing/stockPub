//
//  KLineCell.h
//  stockFront
//
//  Created by wang jam on 2/17/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockInfoModel.h"
#import "StockLookInfoModel.h"

@interface KLineCell : UITableViewCell<UIWebViewDelegate>

- (void)configureCell:(StockInfoModel*)model lookInfo:(StockLookInfoModel*)lookInfo;

+ (NSInteger)cellHeight;

@end
