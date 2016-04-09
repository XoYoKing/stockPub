//
//  StockInfoDetailTableView.h
//  stockFront
//
//  Created by wang jam on 2/7/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockInfoModel.h"
#import <UMSocial.h>
#import <UMSocialData.h>

@interface StockInfoDetailTableView : UITableViewController<UMSocialUIDelegate, UMSocialDataDelegate>

@property StockInfoModel* stockInfoModel;

@property BOOL ismarket;

@end
