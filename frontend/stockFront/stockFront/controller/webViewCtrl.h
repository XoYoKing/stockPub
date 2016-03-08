//
//  webViewCtrl.h
//  stockFront
//
//  Created by wang jam on 3/8/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>

@interface webViewCtrl : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>

- (id)initWithUrl:(NSString*)url title:(NSString*)title;

@end
