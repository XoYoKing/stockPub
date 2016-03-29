//
//  CommentModel.h
//  stockFront
//
//  Created by wang jam on 2/2/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject


@property NSString* look_id;
@property NSString* talk_id;
@property NSString* comment_user_id;
@property NSString* comment_user_name;
@property NSString* comment_user_facethumbnail;
@property NSString* comment_to_user_id;
@property NSString* comment_to_user_name;
@property NSString* comment_content;
@property NSInteger comment_timestamp;
@property NSInteger to_look;
@property NSInteger to_stock;

@end
