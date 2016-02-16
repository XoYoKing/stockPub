//
//  CommentTableViewCell.h
//  stockFront
//
//  Created by wang jam on 2/2/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

- (void)configureCell:(CommentModel*)commentModel;

+ (CGFloat)cellHeight:(NSString*)commentStr;

@end
