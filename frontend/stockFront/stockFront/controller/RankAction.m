//
//  RankAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "RankAction.h"
#import "macro.h"
#import "UserSearchTableViewController.h"

@implementation RankAction
{
    ComTableViewCtrl* comtable;
}

- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    comtable = comTableViewCtrl;
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"排行"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    comTableViewCtrl.navigationItem.titleView = navTitle;
    comTableViewCtrl.view.backgroundColor = [UIColor whiteColor];
    
    comTableViewCtrl.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"找人" style:UIBarButtonItemStylePlain target:self action:@selector(searchPeopleAction:)];
    
}

- (void)searchPeopleAction:(id)sender
{
    UserSearchTableViewController* userSearch = [[UserSearchTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    userSearch.hidesBottomBarWhenPushed = YES;
    [comtable.navigationController pushViewController:userSearch animated:YES];
}

@end
