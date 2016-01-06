//
//  stockAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "stockAction.h"
#import "macro.h"


@implementation stockAction

- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"自选"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    comTableViewCtrl.navigationItem.titleView = navTitle;
    comTableViewCtrl.view.backgroundColor = [UIColor whiteColor];
}

@end
