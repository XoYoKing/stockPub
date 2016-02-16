//
//  FaceCellViewTableViewCell.m
//  stockFront
//
//  Created by wang jam on 1/15/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "FaceCellViewTableViewCell.h"
#import "macro.h"
#import "returnCode.h"
#import <Masonry.h>
#import "FaceImageViewController.h"
#import "Tools.h"
#import "SettingCtrl.h"
#import "ConfigAccess.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YYWebImage.h"
#import "AppDelegate.h"


@implementation FaceCellViewTableViewCell
{
    UIImageView* faceImageView;
    UILabel* userNameLabel;
    UILabel* userYieldLabel;
    UserInfoModel* myInfo;
    //UIButton* followButton;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        faceImageView = [[UIImageView alloc] init];
        faceImageView.userInteractionEnabled = YES;
        [faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceImageViewPress:)]];

        
        userNameLabel = [[UILabel alloc] init];
        userYieldLabel = [[UILabel alloc] init];
        //followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:faceImageView];
        [self addSubview:userNameLabel];
        [self addSubview:userYieldLabel];
        //[self addSubview:followButton];
    }
    return self;
}

- (void)faceImageViewPress:(id)sender
{
    NSLog(@"faceImageViewPress");
    [[Tools curNavigator] presentViewController:[[FaceImageViewController alloc] init:myInfo] animated:YES completion:NULL];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)followAction:(id)sender
//{
//    
//}

- (void)configureCell:(UserInfoModel*)userInfo
{
    myInfo = userInfo;
    if(userInfo.user_facethumbnail == nil){
        faceImageView.image = [UIImage imageNamed:@"man-noname.png"];
    }else{
        
        NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@%@", [ConfigAccess serverDomain], @"/image/?name=", userInfo.user_facethumbnail];
        
        
        [faceImageView sd_setImageWithURL:[[NSURL alloc] initWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            image = [Tools scaleToSize:image size:CGSizeMake(8*minSpace, 8*minSpace)];
            faceImageView.image = image;
        }];
        
    }

    
    
    
    userNameLabel.text = userInfo.user_name;
    userNameLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    
    
    userYieldLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    userYieldLabel.textAlignment = NSTextAlignmentLeft;
    
    if(userInfo.user_look_yield>0){
        userYieldLabel.text = [[NSString alloc] initWithFormat:@"%@+%.2f%%", @"总收益", userInfo.user_look_yield];
        //userYieldLabel.backgroundColor = myred;
        userYieldLabel.textColor = myred;

    }else{
        userYieldLabel.text = [[NSString alloc] initWithFormat:@"%@%.2f%%", @"总收益", userInfo.user_look_yield];
        //userYieldLabel.backgroundColor = mygreen;
        userYieldLabel.textColor = mygreen;

    }
    
    //[followButton setTitle:@"关注" forState:UIControlStateNormal];
    //followButton.backgroundColor = [UIColor blackColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2*minSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8*minSpace, 8*minSpace));
    }];
    faceImageView.clipsToBounds = YES;
    faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    faceImageView.layer.cornerRadius = faceImageView.frame.size.height/2;
    faceImageView.layer.masksToBounds = YES;
    
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(2*minSpace);
        make.top.mas_equalTo(faceImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(180, 3*minSpace));
    }];
    
    [userYieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faceImageView.mas_right).offset(2*minSpace);
        make.top.mas_equalTo(userNameLabel.mas_bottom).offset(minSpace);
        make.size.mas_equalTo(CGSizeMake(20*minSpace, 4*minSpace));
    }];
    
    
//    UserInfoModel* phoneUser = [AppDelegate getMyUserInfo];
//    if ([phoneUser.user_id isEqualToString:myInfo.user_id]) {
//        followButton.hidden = YES;
//    }else{
//        followButton.hidden = NO;
//        
//        [followButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.mas_right).offset(-minSpace);
//            make.centerY.mas_equalTo(userNameLabel.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(6*minSpace, 3*minSpace));
//        }];
//    }
    
}


+ (CGFloat)cellHeight
{
    return 10*minSpace;
}

@end
