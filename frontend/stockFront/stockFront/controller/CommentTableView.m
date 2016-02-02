//
//  CommentTableView.m
//  stockFront
//
//  Created by wang jam on 2/2/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "CommentTableView.h"

#import "macro.h"
#import "returnCode.h"
#import "ComTableViewCtrl.h"
#import "CommentTableViewCell.h"

@implementation CommentTableView
{
    ComTableViewCtrl* comtable;
    NSMutableArray* list;
}


- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"评论"];
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
    static NSString* cellIdentifier = @"commentCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    // Configure the cell...
    if (cell==nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
//    UserInfoModel* userInfo = [list objectAtIndex:indexPath.row];
//    SettingCtrl* settingViewController = [[SettingCtrl alloc] init:userInfo];
//    settingViewController.hidesBottomBarWhenPushed = YES;
//    [comtable.navigationController pushViewController:settingViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel* commentModel = [list objectAtIndex:indexPath.row];
    
    return [CommentTableViewCell cellHeight:commentModel.comment_content];
}

- (void)pullUpAction:(pullCompleted)completedBlock //上拉响应函数
{
    //获取历史comment
}

- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    //获取最近的comment
}



@end
