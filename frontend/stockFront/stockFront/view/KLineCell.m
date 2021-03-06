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
#import "Tools.h"
#import "StockLookInfoModel.h"


@implementation KLineCell
{
    UIWebView* webView;
    BOOL isLoad;
    UIActivityIndicatorView* loadingView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        isLoad = false;
        [self addSubview:webView];
        webView.delegate = self;
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

- (void)webViewDidStartLoad:(UIWebView *)webview
{
    loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 4*minSpace, 4*minSpace)];
    loadingView.center = webView.center;
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [loadingView startAnimating];
    [webView addSubview:loadingView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingView stopAnimating];
    [loadingView removeFromSuperview];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [loadingView stopAnimating];
    [loadingView removeFromSuperview];
    [Tools AlertBigMsg:error.domain];
}


- (void)configureCell:(StockInfoModel*)model lookInfo:(StockLookInfoModel*)lookInfo
{
    if (isLoad == false) {
        
        NSString* urlStr = nil;
        if(lookInfo == nil){
            urlStr = [[NSString alloc] initWithFormat:@"%@%@", [ConfigAccess serverDomain], [[NSString alloc] initWithFormat:@"/stock/kline?stock_code=%@&height=%ld&num_day=%d&width=%f&is_market=%ld", model.stock_code, [KLineCell cellHeight]*3, 66, ScreenWidth*3, model.is_market]];
            NSLog(@"%@", urlStr);

        }else{
            urlStr = [[NSString alloc] initWithFormat:@"%@%@", [ConfigAccess serverDomain], [[NSString alloc] initWithFormat:@"/stock/kline?stock_code=%@&height=%ld&num_day=%d&width=%f&is_market=%ld&look_timestamp=%ld&look_finish_timestamp=%ld", model.stock_code, [KLineCell cellHeight]*3, 66, ScreenWidth*3, model.is_market, lookInfo.look_timestamp, lookInfo.look_finish_timestamp]];
            NSLog(@"%@", urlStr);
        }
        
        
        NSURL* url = [NSURL URLWithString:urlStr];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [webView loadRequest:request];//加载
        isLoad = true;
        webView.userInteractionEnabled = NO;
    }
}

+ (NSInteger)cellHeight
{
    return 28*minSpace;
}

@end
