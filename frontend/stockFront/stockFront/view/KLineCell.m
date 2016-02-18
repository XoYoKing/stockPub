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
#import "ConfigAccess.h"


@implementation KLineCell
{
    UIWebView* webView;
    BOOL isLoad;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        isLoad = false;
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
    if (isLoad == false) {
        NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@", [ConfigAccess serverDomain], [[NSString alloc] initWithFormat:@"/stock/kline?stock_code=%@&height=%ld", model.stock_code, [KLineCell cellHeight]*3]];
        NSLog(@"%@", urlStr);
        
        
        NSURL* url = [NSURL URLWithString:urlStr];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [webView loadRequest:request];//加载
        isLoad = true;
        webView.userInteractionEnabled = NO;
    }
}

+ (NSInteger)cellHeight
{
    return 24*minSpace;
}

@end
