//
//  UserTableView.h
//  stockFront
//
//  Created by wang jam on 2/1/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"

@interface UserTableView : NSObject<ComTableViewDelegate, UITableViewDelegate, UITableViewDataSource>


@property id<pullAction> pullAction;

- (id)init:(NSString*)tableTitle;


@end
