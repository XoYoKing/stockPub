//
//  FaceCellViewTableViewCell.h
//  stockFront
//
//  Created by wang jam on 1/15/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface FaceCellViewTableViewCell : UITableViewCell


+ (CGFloat)cellHeight;

- (void)configureCell:(UserInfoModel*)userInfo;

@end
