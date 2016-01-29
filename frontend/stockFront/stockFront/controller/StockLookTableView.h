//
//  StockLookTableView.h
//  stockFront
//
//  Created by wang jam on 1/29/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComTableViewCtrl.h"

@interface StockLookTableView : NSObject<ComTableViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property id<pullAction> pullAction;

@end
