//
//  StockLookDetailTableViewCell.m
//  stockFront
//
//  Created by wang jam on 1/24/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockLookDetailTableViewCell.h"
#import "macro.h"
#import <Masonry.h>
#import "ConfigAccess.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation StockLookDetailTableViewCell
{
    UIImageView* faceImageView;
    UILabel* lookTimeLabel;
    UILabel* userNameLabel;
    UILabel* userTotalYield;
    UILabel* lookStatusLabel;
    
    UILabel* stockNameLabel;
    UILabel* yieldLabel;
    UILabel* priceLabel;
    
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        faceImageView = [[UIImageView alloc] init];
        lookTimeLabel = [[UILabel alloc] init];
        userNameLabel = [[UILabel alloc] init];
        lookStatusLabel = [[UILabel alloc] init];
        userTotalYield = [[UILabel alloc] init];
        
        stockNameLabel = [[UILabel alloc] init];
        yieldLabel = [[UILabel alloc] init];
        priceLabel = [[UILabel alloc] init];
        
        
        [self addSubview:faceImageView];
        [self addSubview:lookTimeLabel];
        [self addSubview:userNameLabel];
        [self addSubview:lookStatusLabel];
        [self addSubview:stockNameLabel];
        [self addSubview:yieldLabel];
        [self addSubview:priceLabel];
        [self addSubview:userTotalYield];
        
    }
    return self;
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
    if(stockLookInfoModel.user_facethumbnail == nil){
        faceImageView.image = [UIImage imageNamed:@"man-noname.png"];
    }else{
        
        NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@%@", [ConfigAccess serverDomain], @"/image/?name=", stockLookInfoModel.user_facethumbnail];
        
        
        [faceImageView sd_setImageWithURL:[[NSURL alloc] initWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            image = [Tools scaleToSize:image size:CGSizeMake(8*minSpace, 8*minSpace)];
            faceImageView.image = image;
        }];
        
    }
    
    userNameLabel.text = stockLookInfoModel.user_name;
    userNameLabel.font = [UIFont fontWithName:fontName size:minFont];
    
    userTotalYield.font = [UIFont fontWithName:fontName size:minFont];
    if(stockLookInfoModel.user_look_yield>0){
        userTotalYield.text = [[NSString alloc] initWithFormat:@"%@+%.2f%%", @"总收益", stockLookInfoModel.user_look_yield];
        userTotalYield.textColor = myred;
    }else{
        userTotalYield.text = [[NSString alloc] initWithFormat:@"%@%.2f%%", @"总收益", stockLookInfoModel.user_look_yield];
        userTotalYield.textColor = mygreen;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.top.mas_equalTo(self.mas_top).offset(2*minSpace);
        make.size.mas_equalTo(CGSizeMake(6*minSpace, 6*minSpace));
    }];
    faceImageView.layer.cornerRadius = faceImageView.frame.size.height/2;
    faceImageView.layer.masksToBounds = YES;
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(2*minSpace);
        make.top.mas_equalTo(faceImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(180, 3*minSpace));
    }];
    
    [userTotalYield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(2*minSpace);
        make.top.mas_equalTo(userNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(180, 3*minSpace));
    }];
    
    
}

+ (CGFloat)cellHeight
{
    return 15*minSpace;
}

@end
