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


@implementation UnreadCommentStockTableView
{
    NSMutableArray* commentlist;
    NSMutableArray* stocklist;
    BOOL allowPullUp;
    UIActivityIndicatorView* bottomActive;
    InputToolbar* inputToolbar;


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





@end
