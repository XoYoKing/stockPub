//
//  Tools.m
//  stockFront
//
//  Created by wang jam on 1/4/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "Tools.h"
#import <CocoaSecurity.h>


@implementation Tools

+ (NSString*)encodePassword:(NSString*)password
{
    CocoaSecurityResult* encodePassword = [CocoaSecurity md5:password];
    return encodePassword.hexLower;
}
@end
