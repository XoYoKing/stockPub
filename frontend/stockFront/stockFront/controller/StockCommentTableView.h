//
//  StockCommentTableView.h
//  stockFront
//
//  Created by wang jam on 3/16/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"
#import "InputToolbar.h"
#import "CommentModel.h"
#import "StockInfoModel.h"

@interface StockCommentTableView : NSObject<ComTableViewDelegate, UITableViewDataSource, UITableViewDelegate, InputToolbarDelegate>

- (id)initWithStock:(StockInfoModel*)stockModel pullAction:(id<pullAction>)pullAction;

@end
