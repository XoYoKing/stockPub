//
//  StockCommentTableView.m
//  stockFront
//
//  Created by wang jam on 3/16/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockCommentTableView.h"
#import "macro.h"
#import "returnCode.h"
#import "Tools.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "CommentTableViewCell.h"
#import "NetworkAPI.h"

@implementation StockCommentTableView
{
    StockInfoModel* stockmodel;
    ComTableViewCtrl* comtable;
    NSMutableArray* list;
    UserInfoModel* phoneUser;
    UserInfoModel* toUserInfo;
    InputToolbar* inputToolbar;
    id<pullAction> myPullAction;
}

- (id)initWithStock:(StockInfoModel*)stockModel pullAction:(id<pullAction>)pullAction
{
    if(self = [super init]){
        stockmodel = stockModel;
        myPullAction = pullAction;
    }
    return self;
}


- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:stockmodel.stock_name];
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
    static NSString* cellIdentifier = @"commentToStockCell";
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

- (void)sendStockDetailComment:(NSString*)msg
{
    NSInteger to_stock = 0;
    NSString* talk_to_user_id = @"";
    NSString* talk_to_user_name = @"";
    
    if(toUserInfo == nil){
        to_stock = 1;
    }else{
        to_stock = 0;
        talk_to_user_id = toUserInfo.user_id;
        talk_to_user_name = toUserInfo.user_name;
    }
    
    // Create NSData object
    NSData *nsdata = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    
    NSDictionary* message = [[NSDictionary alloc]
               initWithObjects:@[stockmodel.stock_code, phoneUser.user_id, phoneUser.user_name, base64Encoded, talk_to_user_id, talk_to_user_name, [[NSNumber alloc] initWithInteger:to_stock]]
               forKeys:@[@"talk_stock_code", @"talk_user_id", @"user_name", @"talk_content", @"talk_to_user_id", @"talk_to_user_name", @"to_stock"]];
    
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/addCommentToStock" successed:^(NSDictionary *response) {
        
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            CommentModel* commentModel = [[CommentModel alloc] init];
            commentModel.comment_user_id = phoneUser.user_id;
            commentModel.comment_user_name = phoneUser.user_name;
            commentModel.comment_user_facethumbnail = phoneUser.user_facethumbnail;
            commentModel.comment_timestamp = [[NSDate date] timeIntervalSince1970]*1000;
            commentModel.comment_to_user_name = toUserInfo.user_name;
            commentModel.comment_to_user_id = toUserInfo.user_id;
            commentModel.to_stock = to_stock;
            
            if(to_stock == 0){
                commentModel.comment_content = [[NSString alloc] initWithFormat:@"回复%@:%@", commentModel.comment_to_user_name, msg];
            }else{
                commentModel.comment_content = msg;
            }
            
            
            [list insertObject:commentModel atIndex:0];
            
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
        [self sendStockDetailComment:msg];
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
    
    CommentModel* commentModel = [list objectAtIndex:indexPath.row];
    
    if ([phoneUser.user_id isEqualToString:commentModel.comment_user_id]) {
        return;
    }
    
    toUserInfo = [[UserInfoModel alloc] init];
    toUserInfo.user_id = commentModel.comment_user_id;
    toUserInfo.user_name = commentModel.comment_user_name;
    
    inputToolbar = [[InputToolbar alloc] init];
    inputToolbar.inputDelegate = self;
    
    [[Tools curNavigator].view addSubview:inputToolbar];
    
    [inputToolbar showInput];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel* commentModel = [list objectAtIndex:indexPath.row];
    
    return [CommentTableViewCell cellHeight:commentModel.comment_content];
}

- (void)pullUpAction:(pullCompleted)completedBlock //上拉响应函数
{
    [myPullAction pullUpAction:completedBlock list:list tableview:comtable.tableView];
}

- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    [myPullAction pullDownAction:completedBlock list:list tableview:comtable.tableView];
}




@end
