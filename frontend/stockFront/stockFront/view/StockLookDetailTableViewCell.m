//
//  StockLookDetailTableViewCell.m
//  stockFront
//
//  Created by wang jam on 1/24/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockLookDetailTableViewCell.h"
#import "macro.h"


@implementation StockLookDetailTableViewCell
{
    UIImageView* faceImageView;
    UILabel* userNameLabel;
    UILabel* lookStatusLabel;
    UILabel* stockNameLabel;
    UILabel* yieldLabel;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCell:(StockLookInfoModel*)stockLookInfoModel
{
    
}

+ (CGFloat)cellHeight
{
    return 15*minSpace;
}

@end
