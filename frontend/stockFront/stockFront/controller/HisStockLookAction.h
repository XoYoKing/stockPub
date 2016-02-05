//
//  HisStockLookAction.h
//  stockFront
//
//  Created by wang jam on 1/29/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"

@interface HisStockLookAction : NSObject<pullAction>

- (void)pullDownAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview;

- (void)pullUpAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview;

- (id)init:(NSString*)userID;


@end
