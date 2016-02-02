//
//  CommentTableViewCell.m
//  stockFront
//
//  Created by wang jam on 2/2/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import <Masonry.h>
#import "macro.h"
#import "ConfigAccess.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation CommentTableViewCell
{
    UIImageView* faceImageView;
    UILabel* userNameLabel;
    UILabel* commentLabel;
    UILabel* timeLabel;
    CommentModel* myCommentModel;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        faceImageView = [[UIImageView alloc] init];
        userNameLabel = [[UILabel alloc] init];
        commentLabel = [[UILabel alloc] init];
        timeLabel = [[UILabel alloc] init];
        
        
        [self addSubview:faceImageView];
        [self addSubview:userNameLabel];
        [self addSubview:commentLabel];
        [self addSubview:timeLabel];
        
        faceImageView.userInteractionEnabled = YES;
        [faceImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceViewPress:)]];
    }
    return self;
}

- (void)faceViewPress:(id)sender
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        make.left.mas_equalTo(faceImageView.mas_right).offset(minSpace);
        make.top.mas_equalTo(faceImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(180, 3*minSpace));
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(faceImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(9*minSpace, 3*minSpace));
    }];

}



- (void)configureCell:(CommentModel*)commentModel
{
    myCommentModel = commentModel;
    
    if(commentModel.comment_user_facethumbnail == nil){
        faceImageView.image = [UIImage imageNamed:@"man-noname.png"];
    }else{
        
        NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@%@", [ConfigAccess serverDomain], @"/image/?name=", commentModel.comment_user_facethumbnail];
        
        
        [faceImageView sd_setImageWithURL:[[NSURL alloc] initWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //            image = [Tools scaleToSize:image size:CGSizeMake(8*minSpace, 8*minSpace)];
            //            faceImageView.image = image;
        }];
        
    }
    
    userNameLabel.text = commentModel.comment_user_name;
    userNameLabel.font = [UIFont fontWithName:fontName size:minFont];

    timeLabel.font = [UIFont fontWithName:fontName size:minFont];
    timeLabel.text = [Tools showTime:commentModel.comment_timestamp/1000];
    
    
}

+ (CGFloat)cellHeight:(NSString*)commentStr
{
    return 0;
}

@end
