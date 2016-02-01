//
//  RankAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "RankAction.h"
#import "macro.h"

@implementation RankAction

- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
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
    
}

@end
