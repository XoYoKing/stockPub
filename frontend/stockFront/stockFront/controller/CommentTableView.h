//
//  CommentTableView.h
//  stockFront
//
//  Created by wang jam on 2/2/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"
#import "InputToolbar.h"
#import "StockLookInfoModel.h"

@interface CommentTableView : NSObject<ComTableViewDelegate, UITableViewDataSource, UITableViewDelegate, InputToolbarDelegate>

@property StockLookInfoModel* stockLookInfo;


@end
