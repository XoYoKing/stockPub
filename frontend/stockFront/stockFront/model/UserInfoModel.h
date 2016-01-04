//
//  UserInfoModel.h
//  CarSocial
//
//  Created by wang jam on 8/12/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UserInfoModel : NSObject
{
    
    
}

@property NSString* user_id;
@property NSInteger age;
@property NSString* user_name;
@property NSString* user_password;


@property NSString* user_face_image;
@property NSString* user_facethumbnail;

@property NSString* device_token;


@property NSString* user_phone;


@property NSInteger user_fans_count;
@property NSInteger user_follow_count;


@end
