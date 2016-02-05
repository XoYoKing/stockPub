//
//  RankCell.m
//  stockFront
//
//  Created by wang jam on 2/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "RankCell.h"
#import "SettingCtrl.h"
#import "Tools.h"
#import "macro.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ConfigAccess.h"
#import <Masonry.h>


@implementation RankCell
{
    UIImageView* faceImageView;
    UILabel* userNameLabel;
    UILabel* commentLabel;
    UILabel* yieldLabel;
    RankModel* rankModel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        faceImageView = [[UIImageView alloc] init];
        userNameLabel = [[UILabel alloc] init];
        commentLabel = [[UILabel alloc] init];
        yieldLabel = [[UILabel alloc] init];
        
        [self addSubview:faceImageView];
        [self addSubview:userNameLabel];
        [self addSubview:commentLabel];
        [self addSubview:yieldLabel];
        
        faceImageView.userInteractionEnabled = YES;
        [faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceViewPress:)]];
    }
    return self;
}

- (void)faceViewPress:(id)sender
{
//    UserInfoModel* userInfo = [[UserInfoModel alloc] init];
//    userInfo.user_id = rankModel.user_id;
//    userInfo.user_facethumbnail = rankModel.user_facethumbnail;
//    
//    SettingCtrl* settingViewController = [[SettingCtrl alloc] init:userInfo];
//    settingViewController.hidesBottomBarWhenPushed = YES;
//    [[Tools curNavigator] pushViewController:settingViewController animated:YES];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6*minSpace, 6*minSpace));
    }];
    faceImageView.layer.cornerRadius = faceImageView.frame.size.height/2;
    faceImageView.layer.masksToBounds = YES;
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(minSpace);
        make.top.mas_equalTo(faceImageView.mas_top).offset(minSpace/2);
        make.size.mas_equalTo(CGSizeMake(170, 3*minSpace));
    }];

    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(minSpace);
        make.top.mas_equalTo(userNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(160, 3*minSpace));
    }];
    
    
    
    [yieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-2*minSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/4 - minSpace/2, 4*minSpace));
    }];
    
}

- (void)configureCell:(RankModel*)model
{
    rankModel = model;
    
    if(model.user_facethumbnail == nil||[model.user_facethumbnail isEqualToString:@""]){
        faceImageView.image = [UIImage imageNamed:@"man-noname.png"];
    }else{
        
        NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@%@", [ConfigAccess serverDomain], @"/image/?name=", rankModel.user_facethumbnail];
        
        
        [faceImageView sd_setImageWithURL:[[NSURL alloc] initWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //            image = [Tools scaleToSize:image size:CGSizeMake(8*minSpace, 8*minSpace)];
            //            faceImageView.image = image;
        }];
        
    }
    
    userNameLabel.text = model.user_name;
    userNameLabel.font = [UIFont fontWithName:fontName size:minFont];
    
    
    yieldLabel.font = [UIFont fontWithName:fontName size:minFont];
    
    yieldLabel.textAlignment = NSTextAlignmentCenter;
    
    if (rankModel.total_yield>0) {
        yieldLabel.textColor = [UIColor whiteColor];
        yieldLabel.text = [[NSString alloc] initWithFormat:@"+%.2lf%%", rankModel.total_yield];
        yieldLabel.backgroundColor = myred;
    }
    
    if(rankModel.total_yield<=0){
        yieldLabel.textColor = [UIColor whiteColor];
        yieldLabel.text = [[NSString alloc] initWithFormat:@"%.2lf%%", rankModel.total_yield];
        yieldLabel.backgroundColor = mygreen;
    }
    
    
    NSString* commentText = @"";
    for (NSDictionary* stock in rankModel.stocklist) {
        NSString* stock_code = [stock objectForKey:@"stock_code"];
        NSString* stock_name = [stock objectForKey:@"stock_name"];
        stock_name = [stock_name stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([commentText isEqualToString:@""]){
            commentText = stock_name;
        }else{
            commentText = [[NSString alloc] initWithFormat:@"%@,%@", commentText, stock_name];
        }
    }
    
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.font = [UIFont fontWithName:fontName size:microFont];
    commentLabel.text = commentText;
    commentLabel.textColor = [UIColor grayColor];
    
}

+ (CGFloat)cellHeight:(NSArray*)stocklist
{
    return 10*minSpace;
}

@end
