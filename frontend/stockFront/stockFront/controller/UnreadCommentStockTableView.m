//
//  UnreadCommentStockTableView.m
//  stockFront
//
//  Created by wang jam on 3/28/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "UnreadCommentStockTableView.h"
#import "macro.h"
#import "returnCode.h"
#import "AppDelegate.h"
#import "NetworkAPI.h"
#import "StockInfoModel.h"
#import <YYModel.h>
#import "CommentModel.h"
#import "CommentTableViewCell.h"
#import "StockActionTableViewCell.h"
#import "StockInfoDetailTableView.h"


@implementation UnreadCommentStockTableView
{
    NSMutableArray* commentlist;
    NSMutableArray* stocklist;
    BOOL allowPullUp;
    UIActivityIndicatorView* bottomActive;
    InputToolbar* inputToolbar;
    UserInfoModel* toUserInfo;
    StockInfoModel* toStock;

}
static int bottomActiveHeight = 30;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"个股评论"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullDownAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    
    commentlist = [[NSMutableArray alloc] init];
    stocklist = [[NSMutableArray alloc] init];
    
    [self pullDownAction];
    
    [self setBottomActive];
    allowPullUp = true;
}


- (void)setBottomActive
{
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, bottomActiveHeight*2)];
    [self.tableView setTableFooterView:bottomView];
    
    bottomActive = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    bottomActive.frame = CGRectMake((ScreenWidth - bottomActiveHeight)/2, (self.tableView.tableFooterView.frame.size.height - bottomActiveHeight)/2, bottomActiveHeight, bottomActiveHeight);
    [bottomActive setColor:[UIColor grayColor]];
    [bottomActive hidesWhenStopped];
    
    for (UIView* view in self.tableView.tableFooterView.subviews) {
        [view removeFromSuperview];
    }
    [self.tableView.tableFooterView addSubview:bottomActive];
}

- (void)pullDownAction
{
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[userInfo.user_id, [[NSNumber alloc] initWithInteger:[[NSDate date] timeIntervalSince1970]*1000]]
                             forKeys:@[@"user_id", @"talk_timestamp_ms"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getCommentToStockByUser" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [stocklist removeAllObjects];
            [commentlist removeAllObjects];
            
            NSArray* unreadCommentArray = (NSArray*)[response objectForKey:@"data"];
            
            if(unreadCommentArray!=nil){
                for (NSDictionary* element in unreadCommentArray) {
                    
                    StockInfoModel* stockInfo = nil;
                    if([[element objectForKey:@"is_market"] integerValue] == 1){
                        stockInfo = [[StockInfoModel alloc] init];
                        NSDictionary* marketObject = [element objectForKey:@"stockInfo"];
                        stockInfo.stock_code = [marketObject objectForKey:@"market_code"];
                        stockInfo.stock_name = [marketObject objectForKey:@"market_name"];
                        stockInfo.price = [[marketObject objectForKey:@"market_index_value_now"] floatValue];
                        stockInfo.fluctuate = [[marketObject objectForKey:@"market_index_fluctuate"] floatValue];
                        stockInfo.fluctuate_value = [[marketObject objectForKey:@"market_index_fluctuate_value"] floatValue];
                        stockInfo.is_market = 1;
                        
                    }else{
                        stockInfo = [StockInfoModel yy_modelWithDictionary:[element objectForKey:@"stockInfo"]];
                    }
              
                    
                    CommentModel* commentModel = [[CommentModel alloc] init];
                    commentModel.talk_id = [element objectForKey:@"talk_id"];
                    
                    commentModel.comment_user_id = [element objectForKey:@"talk_user_id"];
                    commentModel.comment_user_name = [element objectForKey:@"user_name"];
                    commentModel.comment_user_facethumbnail = [element objectForKey:@"user_facethumbnail"];
                    commentModel.comment_content = [element objectForKey:@"talk_content"];
                    commentModel.comment_timestamp = [[element objectForKey:@"talk_timestamp_ms"] integerValue]/1000;
                    
                    [stocklist addObject:stockInfo];
                    [commentlist addObject:commentModel];
                }
            }
            
        }else{
            alertMsg(@"未知错误");
        }
        
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    }];
}


- (void)pullUpAction
{
    CommentModel* commentModel = [commentlist lastObject];
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[userInfo.user_id, [[NSNumber alloc] initWithInteger:commentModel.comment_timestamp*1000]]
                             forKeys:@[@"user_id", @"talk_timestamp_ms"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getCommentToStockByUser" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            
            NSArray* unreadCommentArray = (NSArray*)[response objectForKey:@"data"];
            
            if(unreadCommentArray!=nil){
                for (NSDictionary* element in unreadCommentArray) {
                    StockInfoModel* stockInfo = [StockInfoModel yy_modelWithDictionary:[element objectForKey:@"stockInfo"]];
                    CommentModel* commentModel = [[CommentModel alloc] init];
                    commentModel.talk_id = [element objectForKey:@"talk_id"];

                    commentModel.comment_user_id = [element objectForKey:@"talk_user_id"];
                    commentModel.comment_user_name = [element objectForKey:@"user_name"];
                    commentModel.comment_user_facethumbnail = [element objectForKey:@"user_facethumbnail"];
                    commentModel.comment_content = [element objectForKey:@"talk_content"];
                    commentModel.comment_timestamp = [[element objectForKey:@"talk_timestamp_ms"] integerValue]/1000;
                    
                    
                    [stocklist addObject:stockInfo];
                    [commentlist addObject:commentModel];
                }
            }
            
            if([unreadCommentArray count] == 0){
                allowPullUp = NO;
            }
            
        }else{
            alertMsg(@"未知错误");
        }
        
        [bottomActive stopAnimating];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        
        [bottomActive stopAnimating];
        [self.tableView reloadData];
        
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(allowPullUp == YES){
        CGPoint off = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        CGFloat currentOffset = off.y + bounds.size.height;
        CGFloat maximumOffset = size.height;
        
        if ([bottomActive isAnimating]) {
            return;
        }
        
        if((currentOffset - maximumOffset)>64.0&&maximumOffset>bounds.size.height){
            
            [bottomActive startAnimating];
            [self pullUpAction];
        }
    }
    
    
    if (scrollView == self.tableView) {
        //[myTextField resignFirstResponder];
        if (inputToolbar!=nil) {
            [inputToolbar hideInput];
            [inputToolbar removeFromSuperview];
            inputToolbar = nil;
            
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [StockActionTableViewCell cellHeight];
    }
    
    if (indexPath.row == 1) {
        CommentModel* commentmodel = [commentlist objectAtIndex:indexPath.section];
        
        return [CommentTableViewCell cellHeight:commentmodel.comment_content];
    }
    
    return 0;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString* cellIdentifier = @"stockcell";
        StockActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[StockActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        [cell configureCell:[stocklist objectAtIndex:indexPath.section]];
        
        return cell;
    }
    
    
    if (indexPath.row == 1) {
        static NSString* cellIdentifier = @"commentcell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        [cell configureCell:[commentlist objectAtIndex:indexPath.section]];
        
        return cell;
    }
    
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [commentlist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return minSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return minSpace;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel* phoneUser = [AppDelegate getMyUserInfo];
    
    if (indexPath.row == 0) {
        StockInfoModel* model = [stocklist objectAtIndex:indexPath.section];
        StockInfoDetailTableView* tableviewCtrl = [[StockInfoDetailTableView alloc] init];
        tableviewCtrl.stockInfoModel = model;
        tableviewCtrl.ismarket = model.is_market;
        
        tableviewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tableviewCtrl animated:YES];
    }
    
    if (indexPath.row == 1) {
        CommentModel* commentModel = [commentlist objectAtIndex:indexPath.section];
        
        if (![phoneUser.user_id isEqualToString:commentModel.comment_user_id]) {
            
            toUserInfo = [[UserInfoModel alloc] init];
            toUserInfo.user_id = commentModel.comment_user_id;
            toUserInfo.user_name = commentModel.comment_user_name;
            
            toStock = [stocklist objectAtIndex:indexPath.section];
            
            inputToolbar = [[InputToolbar alloc] init];
            inputToolbar.inputDelegate = self;
            
            [[Tools curNavigator].view addSubview:inputToolbar];
            
            
            [inputToolbar showInput];
        }
        
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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


- (void)sendDetailComment:(NSString*)msg
{
    
    NSInteger to_stock = 0;
    NSString* comment_to_user_id = @"";
    NSString* comment_to_user_name = @"";
    to_stock = 0;
    comment_to_user_id = toUserInfo.user_id;
    comment_to_user_name = toUserInfo.user_name;
    
    UserInfoModel* phoneUser = [AppDelegate getMyUserInfo];
    
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[toStock.stock_code,
                                               phoneUser.user_id,
                                               phoneUser.user_name,
                                               comment_to_user_id,
                                               msg,
                                               [[NSNumber alloc] initWithInteger:to_stock]]
                             forKeys:@[@"talk_stock_code",
                                       @"talk_user_id",
                                       @"user_name",
                                       @"comment_to_user_id",
                                       @"talk_content",
                                       @"to_stock"]];
    
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/addCommentToLook" successed:^(NSDictionary *response) {
        
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [Tools AlertBigMsg:@"回复成功"];
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (inputToolbar!=nil) {
        [inputToolbar hideInput];
        [inputToolbar removeFromSuperview];
        inputToolbar = nil;
    }
}

@end
