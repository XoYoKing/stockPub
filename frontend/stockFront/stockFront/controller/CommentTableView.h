//
//  CommentTableView.h
//  stockFront
//
//  Created by wang jam on 2/2/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"


@interface CommentTableView : NSObject<ComTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSString* look_id;


@end
