//
//  KLineCell.m
//  stockFront
//
//  Created by wang jam on 2/17/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "KLineCell.h"
#import "macro.h"
#import "returnCode.h"
#import <Masonry.h>


@implementation KLineCell
{
    UIWebView* webView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        [self addSubview:webView];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.size.mas_equalTo(self.frame.size);
    }];
}



- (void)configureCell:(StockInfoModel*)model
{
    NSURL* url = [NSURL URLWithString:@"http://112.74.102.178:10808/eula"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
}

+ (CGFloat)cellHeight
{
    return 22*minSpace;
}

@end
