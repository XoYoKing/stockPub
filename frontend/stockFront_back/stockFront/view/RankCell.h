//
//  RankCell.h
//  stockFront
//
//  Created by wang jam on 2/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"

@interface RankCell : UITableViewCell

- (void)configureCell:(RankModel*)model;

+ (CGFloat)cellHeight:(NSArray*)stocklist;

@end
