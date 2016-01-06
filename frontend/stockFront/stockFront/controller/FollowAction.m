//
//  FollowAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "FollowAction.h"
#import "macro.h"

@implementation FollowAction

- (void)initAction:(ComTableViewCtrl*)comTableViewCtrl
{
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"关注"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    comTableViewCtrl.navigationItem.titleView = navTitle;
    comTableViewCtrl.view.backgroundColor = [UIColor whiteColor];
    
    
    //    UIButton* rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBar.frame = CGRectMake(0, 0, 24, 24);
    //    [rightBar setBackgroundImage:[UIImage imageNamed:@"publishActivity48.png"] forState:UIControlStateNormal];
    //    [rightBar addTarget:self action:@selector(publishActivity:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
    //    comTable.navigationItem.rightBarButtonItem = rightitem;
    
    
    //    leftBar = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftBar.frame = CGRectMake(0, 0, leftbarWidth, leftbarWidth);
    //    [leftBar setBackgroundImage:[UIImage imageNamed:@"info-icon.png"] forState:UIControlStateNormal];
    //
    //    [leftBar addTarget:self action:@selector(sideMenuOpen) forControlEvents:UIControlEventTouchUpInside];
    //    comTable.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBar];
    
    
    //注册右滑动事件
    //    UISwipeGestureRecognizer *swapRight = [[UISwipeGestureRecognizer  alloc] initWithTarget:self action:@selector(sideMenuOpen)];
    //    swapRight.direction = UISwipeGestureRecognizerDirectionRight;
    //    [comTableViewCtrl.view addGestureRecognizer:swapRight];
    //
    //    //注册左滑动事件
    //    UISwipeGestureRecognizer *swapLeft = [[UISwipeGestureRecognizer  alloc] initWithTarget:self action:@selector(sideMenuClose)];
    //    swapLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    //    [comTableViewCtrl.view addGestureRecognizer:swapLeft];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pullDown) name:@"pullDown" object:nil];
    
}


@end
