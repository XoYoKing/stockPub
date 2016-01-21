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
#import "AppDelegate.h"

@implementation Tools

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize
{
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(newsize, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(newsize);
    }
    
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    if (scaledImage == nil) {
        scaledImage = img;
    }
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

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

+ (UINavigationController*)curNavigator
{
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return (UINavigationController*)app.tabBarViewController.selectedViewController;
    
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
