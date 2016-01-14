//
//  Tools.m
//  stockFront
//
//  Created by wang jam on 1/4/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "Tools.h"
#import <CocoaSecurity.h>
#import <MBProgressHUD.h>

@implementation Tools

+ (NSString*)encodePassword:(NSString*)password
{
    CocoaSecurityResult* encodePassword = [CocoaSecurity md5:password];
    return encodePassword.hexLower;
}

+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

+ (void)AlertMsg:(NSString*)msg
{
    UIViewController* viewCtrl = [Tools appRootViewController];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewCtrl.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (void)AlertBigMsg:(NSString*)msg
{
    UIViewController* viewCtrl = [Tools appRootViewController];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewCtrl.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

+ (CGSize)getTextArrange:(NSString*)text maxRect:(CGSize)maxRect fontSize:(int)fontSize
{
    CGRect size = [text boundingRectWithSize:maxRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return CGSizeMake(size.size.width, size.size.height);
}


@end
