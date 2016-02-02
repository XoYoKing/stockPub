//
//  UserTableView.m
//  stockFront
//
//  Created by wang jam on 2/1/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "UserTableView.h"
#import "macro.h"
#import "returnCode.h"
#import "FaceCellViewTableViewCell.h"
#import "SettingCtrl.h"

@implementation UserTableView
{
    NSMutableArray* list;
    ComTableViewCtrl* comtable;
    NSString* title;
}

- (id)init:(NSString*)tableTitle
{
    if(self = [super init]){
        title = tableTitle;
    }
    return self;
}

- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:title];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    comTableViewCtrl.navigationItem.titleView = navTitle;
    comTableViewCtrl.view.backgroundColor = [UIColor whiteColor];
    
    comtable = comTableViewCtrl;
    [comTableViewCtrl.tableView setDelegate:self];
    [comTableViewCtrl.tableView setDataSource:self];
    
    list = [[NSMutableArray alloc] init];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"userTableViewCell";
    FaceCellViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    // Configure the cell...
    if (cell==nil) {
        cell = [[FaceCellViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSLog(@"new cell");
    }
    
    
    [cell configureCell:[list objectAtIndex:indexPath.row]];
    
    return cell;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [list count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel* userInfo = [list objectAtIndex:indexPath.row];
    SettingCtrl* settingViewController = [[SettingCtrl alloc] init:userInfo];
    settingViewController.hidesBottomBarWhenPushed = YES;
    [comtable.navigationController pushViewController:settingViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FaceCellViewTableViewCell cellHeight];
}

- (void)pullUpAction:(pullCompleted)completedBlock //上拉响应函数
{
    if(_pullAction!=nil&&[_pullAction respondsToSelector:@selector(pullUpAction:list:tableview:)]){
        [_pullAction pullUpAction:completedBlock list:list tableview:comtable.tableView];
    }else{
        completedBlock();
    }
}

- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    if(_pullAction!=nil&&[_pullAction respondsToSelector:@selector(pullDownAction:list:tableview:)]){
        [_pullAction pullDownAction:completedBlock list:list tableview:comtable.tableView];
    }else{
        completedBlock();
    }
}

@end
