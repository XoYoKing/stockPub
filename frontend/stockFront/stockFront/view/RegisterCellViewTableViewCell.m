//
//  RegisterCellViewTableViewCell.m
//  CarSocial
//
//  Created by wang jam on 9/2/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import "RegisterCellViewTableViewCell.h"
#import "macro.h"
#import <Masonry.h>

@implementation RegisterCellViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 6*minSpace;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(2*minSpace, minSpace, 4*minSpace, 4*minSpace)];
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(4*minSpace);
        make.centerY.mas_equalTo(self.imageView.mas_centerY);
    }];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
