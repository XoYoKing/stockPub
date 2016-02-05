//
//  FollowInfoModel.h
//  stockFront
//
//  Created by wang jam on 2/1/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowInfoModel : NSObject

@property NSString* user_id;
@property NSString* followed_user_id;
@property NSInteger follow_timestamp;

@end
