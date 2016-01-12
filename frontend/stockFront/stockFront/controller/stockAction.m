//
//  stockAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "stockAction.h"
#import "macro.h"
#import "StockSearchTableViewCtrl.h"


@implementation stockAction
{
    ComTableViewCtrl* comTable;
}

- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"自选"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    comTableViewCtrl.navigationItem.titleView = navTitle;
    comTableViewCtrl.view.backgroundColor = [UIColor whiteColor];
    
    comTableViewCtrl.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    comTable = comTableViewCtrl;
}

- (void)searchAction:(id)sender
{
    StockSearchTableViewCtrl* stockSearch = [[StockSearchTableViewCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    stockSearch.hidesBottomBarWhenPushed = YES;
    [comTable.navigationController pushViewController:stockSearch animated:YES];
}




@end
