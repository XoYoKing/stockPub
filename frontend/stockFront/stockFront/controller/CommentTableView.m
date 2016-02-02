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
#import "NetworkAPI.h"
#import <YYModel.h>
#import "InputToolbar.h"
#import "NetworkAPI.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"

@implementation CommentTableView
{
    ComTableViewCtrl* comtable;
    NSMutableArray* list;
    InputToolbar* inputToolbar;
    UserInfoModel* toUserInfo;
    UserInfoModel* phoneUser;
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
    
    comTableViewCtrl.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加评论" style:UIBarButtonItemStylePlain target:self action:@selector(addComment:)];
    
    phoneUser = [AppDelegate getMyUserInfo];
    
}


- (void)addComment:(id)sender
{
    toUserInfo = nil;
    
    inputToolbar = [[InputToolbar alloc] init];
    inputToolbar.inputDelegate = self;
    
    [[Tools curNavigator].view addSubview:inputToolbar];
    
    [inputToolbar showInput];
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

- (void)tableViewWillDisappear:(ComTableViewCtrl *)comTableViewCtrl
{
    if (inputToolbar!=nil) {
        [inputToolbar hideInput];
        [inputToolbar removeFromSuperview];
        inputToolbar = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([comtable respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [comtable scrollViewDidScroll:scrollView];
    }
    
    if (scrollView == comtable.tableView) {
        //[myTextField resignFirstResponder];
        if (inputToolbar!=nil) {
            [inputToolbar hideInput];
            [inputToolbar removeFromSuperview];
            inputToolbar = nil;

        }
    }
}

- (void)sendDetailComment:(NSString*)msg
{
    
    NSInteger to_look = 0;
    NSString* comment_to_user_id = @"";
    NSString* comment_to_user_name = @"";
    if(toUserInfo == nil){
        to_look = 1;
        comment_to_user_id = @"";
        comment_to_user_name = @"";
    }else{
        to_look = 0;
        comment_to_user_id = toUserInfo.user_id;
        comment_to_user_name = toUserInfo.user_name;
    }
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_stockLookInfo.look_id, phoneUser.user_id, phoneUser.user_name, comment_to_user_id, msg, [[NSNumber alloc] initWithInteger:to_look]]
                             forKeys:@[@"look_id", @"comment_user_id", @"comment_user_name", @"comment_to_user_id", @"comment_content", @"to_look"]];
    
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/addCommentToLook" successed:^(NSDictionary *response) {
        
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            CommentModel* commentModel = [[CommentModel alloc] init];
            commentModel.comment_user_id = phoneUser.user_id;
            commentModel.comment_user_name = phoneUser.user_name;
            commentModel.comment_user_facethumbnail = phoneUser.user_facethumbnail;
            commentModel.comment_content = msg;
            commentModel.comment_timestamp = [[NSDate date] timeIntervalSince1970]*1000;
            commentModel.comment_to_user_name = comment_to_user_name;
            commentModel.comment_to_user_id = comment_to_user_id;
            commentModel.look_id = _stockLookInfo.look_id;
            [list addObject:commentModel];
            
            [comtable.tableView reloadData];
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
    }];

}

- (void)sendAction:(NSString*)msg
{
    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (msg.length==0||msg==nil) {
        return;
    }

    if(inputToolbar!=nil){
        [inputToolbar hideInput];
        [inputToolbar removeFromSuperview];
        inputToolbar = nil;
        [self sendDetailComment:msg];
    }
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
    
    CommentModel* model = [list lastObject];
    
    //获取历史comment
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_stockLookInfo.look_id,
                                               [[NSNumber alloc] initWithInteger:model.comment_timestamp]]
                             forKeys:@[@"look_id", @"comment_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getComments" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){

            NSArray* commentlist = (NSArray*)[response objectForKey:@"data"];
            
            if(commentlist!=nil){
                for (NSDictionary* element in commentlist) {
                    CommentModel* temp = [CommentModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                
                [comtable.tableView reloadData];
            }
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
        completedBlock();
    }];

}

- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    //获取最近的comment
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_stockLookInfo.look_id,
                                               [[NSNumber alloc] initWithInteger:[[NSDate date] timeIntervalSince1970]*1000]]
                             forKeys:@[@"look_id", @"comment_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getComments" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [list removeAllObjects];
            
            NSArray* commentlist = (NSArray*)[response objectForKey:@"data"];
            
            if(commentlist!=nil){
                for (NSDictionary* element in commentlist) {
                    CommentModel* temp = [CommentModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                
                [comtable.tableView reloadData];
            }
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
        completedBlock();
    }];
    
    
}



@end
