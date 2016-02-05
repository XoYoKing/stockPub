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
#import "NetworkAPI.h"

typedef enum {
    week,
    month,
    quarter,
    year
} rankBy;

@implementation RankAction
{
    ComTableViewCtrl* comtable;
    rankBy rankby;
    UIAlertAction *weekAction;
    UIAlertAction *monthAction;
    UIAlertAction *quarterAction;
    UIAlertAction *yearAction;
}



- (void)showRankButton
{
    if (rankby == week) {
        comtable.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"最近一周" style:UIBarButtonItemStylePlain target:self action:@selector(showRankList)];
    }
    
    if (rankby == month) {
        comtable.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"最近一月" style:UIBarButtonItemStylePlain target:self action:@selector(showRankList)];
    }
    
    if (rankby == quarter) {
        comtable.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"最近三月" style:UIBarButtonItemStylePlain target:self action:@selector(showRankList)];
    }
    
    if (rankby == year) {
        comtable.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"最近一年" style:UIBarButtonItemStylePlain target:self action:@selector(showRankList)];
    }
}


- (void)pullDownAction:(pullCompleted)completedBlock
{
    
}

//- (void)pullUpAction:(pullCompleted)completedBlock
//{
//    
//}


- (void)handleRankChoose:(rankBy)rankOption
{
    NSLog(@"%d", rankby);
    rankby = rankOption;
    [self showRankButton];
    
    
}

- (void)showRankList
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"收益率排名" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    
    
//    [UIAlertAction actionWithTitle:<#(nullable NSString *)#> style:<#(UIAlertActionStyle)#> handler:^(UIAlertAction * _Nonnull action) {
//        [self handleRankChoose:week];
//    }];
    
    weekAction= [UIAlertAction actionWithTitle:@"最近一周" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleRankChoose:week];
    }];
    
    monthAction = [UIAlertAction actionWithTitle:@"最近一月" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleRankChoose:month];
    }];
    
    quarterAction = [UIAlertAction actionWithTitle:@"最近三月" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleRankChoose:quarter];
    }];

    yearAction = [UIAlertAction actionWithTitle:@"最近一年" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleRankChoose:year];
    }];


    [alertController addAction:cancelAction];
    [alertController addAction:weekAction];
    [alertController addAction:monthAction];
    [alertController addAction:quarterAction];
    [alertController addAction:yearAction];
    
    [comtable presentViewController:alertController animated:YES completion:nil];
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
    
    rankby = week;
    
    [self showRankButton];
    
}

- (void)searchPeopleAction:(id)sender
{
    UserSearchTableViewController* userSearch = [[UserSearchTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    userSearch.hidesBottomBarWhenPushed = YES;
    [comtable.navigationController pushViewController:userSearch animated:YES];
}

@end
