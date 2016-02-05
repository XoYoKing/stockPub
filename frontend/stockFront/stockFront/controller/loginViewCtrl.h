//
//  loginViewCtrl.h
//  stockFront
//
//  Created by wang jam on 1/3/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface loginViewCtrl : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (void)sendLoginMessage:(UserInfoModel*)userInfo;

@end
