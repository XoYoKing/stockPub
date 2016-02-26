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


+ (NSString*)showTimeFormat:(long)timeStamp
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yy-MM-dd HH:MM:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    return [formatter stringFromDate:date];
}

+ (NSString*)showTime:(long)timeStamp
{
    long nowTimeStamp = [[NSDate date] timeIntervalSince1970];
    int intervals = abs((int)timeStamp - (int)nowTimeStamp);
    int mins;
    int hours;
    int days;
    NSString* showTimeStr;
    
    if (intervals<3600) {
        mins = intervals/60;
        showTimeStr = [[NSString alloc] initWithFormat:@"%d分钟前", mins];
    }
    else if (intervals<3600*24) {
        hours = intervals/3600;
        showTimeStr = [[NSString alloc] initWithFormat:@"%d小时前", hours];
    }
    else{
        days = intervals/(3600*24);
        if (days>7) {
            showTimeStr = [[NSString alloc] initWithFormat:@"%d周前", days/7];
        }else{
            showTimeStr = [[NSString alloc] initWithFormat:@"%d天前", days];
        }
    }
    return showTimeStr;
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
    [hud hide:YES afterDelay:1.5];
}

+ (CGSize)getTextArrange:(NSString*)text maxRect:(CGSize)maxRect fontSize:(int)fontSize
{
    CGRect size = [text boundingRectWithSize:maxRect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return CGSizeMake(size.size.width, size.size.height);
}


@end
