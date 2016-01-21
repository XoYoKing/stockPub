//
//  Tools.h
//  stockFront
//
//  Created by wang jam on 1/4/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tools : NSObject


+ (NSString*)encodePassword:(NSString*)password;
+ (void)AlertMsg:(NSString*)msg;
+ (void)AlertBigMsg:(NSString*)msg;
+ (CGSize)getTextArrange:(NSString*)text maxRect:(CGSize)maxRect fontSize:(int)fontSize;
+ (UINavigationController*)curNavigator;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
@end
