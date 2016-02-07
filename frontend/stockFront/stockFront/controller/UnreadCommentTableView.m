//
//  UnreadCommentTableView.m
//  stockFront
//
//  Created by wang jam on 2/6/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "UnreadCommentTableView.h"
#import "macro.h"
#import "NetworkAPI.h"
#import "returnCode.h"
#import "Tools.h"
#import "StockLookInfoModel.h"
#import "CommentModel.h"
#import <YYModel.h>
#import "CommentTableViewCell.h"
#import "StockLookTableViewCell.h"
#import "StockLookDetailTableViewController.h"
#import "AppDelegate.h"
#import "InputToolbar.h"

@interface UnreadCommentTableView ()
{
    NSMutableArray* commentlist;
    NSMutableArray* looklist;
    UserInfoModel* toUserInfo;
    StockLookInfoModel* toStockLook;
    InputToolbar* inputToolbar;
    UIActivityIndicatorView* bottomActive;
    BOOL allowPullUp;

}
@end

@implementation UnreadCommentTableView
static int bottomActiveHeight = 30;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"评论"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullDownAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    
    commentlist = [[NSMutableArray alloc] init];
    looklist = [[NSMutableArray alloc] init];
    
    [self pullDownAction];
    
    [self setBottomActive];
    allowPullUp = true;
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


- (void)pullUpAction
{
    CommentModel* commentModel = [commentlist lastObject];
    
    
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_userInfo.user_id, [[NSNumber alloc] initWithInteger:commentModel.comment_timestamp]]
                             forKeys:@[@"user_id", @"comment_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getUnreadComment" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            
            NSArray* unreadCommentArray = (NSArray*)[response objectForKey:@"data"];
            
            if(unreadCommentArray!=nil){
                for (NSDictionary* element in unreadCommentArray) {
                    StockLookInfoModel* stockLookInfo = [StockLookInfoModel yy_modelWithDictionary:element];
                    CommentModel* commentModel = [CommentModel yy_modelWithDictionary:element];
                    
                    [looklist addObject:stockLookInfo];
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

- (void)pullDownAction
{
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_userInfo.user_id, [[NSNumber alloc] initWithInteger:[[NSDate date] timeIntervalSince1970]*1000]]
                             forKeys:@[@"user_id", @"comment_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getUnreadComment" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [looklist removeAllObjects];
            [commentlist removeAllObjects];
            
            NSArray* unreadCommentArray = (NSArray*)[response objectForKey:@"data"];
            
            if(unreadCommentArray!=nil){
                for (NSDictionary* element in unreadCommentArray) {
                    StockLookInfoModel* stockLookInfo = [StockLookInfoModel yy_modelWithDictionary:element];
                    CommentModel* commentModel = [CommentModel yy_modelWithDictionary:element];
                    
                    [looklist addObject:stockLookInfo];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [StockLookTableViewCell cellHeight];
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
        
        static NSString* cellIdentifier = @"lookcell";
        StockLookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[StockLookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        [cell configureCell:[looklist objectAtIndex:indexPath.section]];
        
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [commentlist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
        StockLookInfoModel* model = [looklist objectAtIndex:indexPath.section];
        
        model.user_id = phoneUser.user_id;
        model.user_facethumbnail = phoneUser.user_facethumbnail;
        model.user_name = phoneUser.user_name;
        model.user_look_yield = phoneUser.user_look_yield;
        
        StockLookDetailTableViewController* tableviewCtrl = [[StockLookDetailTableViewController alloc] init];
        tableviewCtrl.stockLookInfoModel = model;
        tableviewCtrl.stocklist = looklist;
        tableviewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tableviewCtrl animated:YES];
    }
    
    if (indexPath.row == 1) {
        CommentModel* commentModel = [commentlist objectAtIndex:indexPath.section];
        
        if (![phoneUser.user_id isEqualToString:commentModel.comment_user_id]) {
            
            toUserInfo = [[UserInfoModel alloc] init];
            toUserInfo.user_id = commentModel.comment_user_id;
            toUserInfo.user_name = commentModel.comment_user_name;
            
            toStockLook = [looklist objectAtIndex:indexPath.section];
            
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
    
    NSInteger to_look = 0;
    NSString* comment_to_user_id = @"";
    NSString* comment_to_user_name = @"";
    to_look = 0;
    comment_to_user_id = toUserInfo.user_id;
    comment_to_user_name = toUserInfo.user_name;
    
    UserInfoModel* phoneUser = [AppDelegate getMyUserInfo];

    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[toStockLook.look_id, phoneUser.user_id, phoneUser.user_name, comment_to_user_id, msg, [[NSNumber alloc] initWithInteger:to_look]]
                             forKeys:@[@"look_id", @"comment_user_id", @"comment_user_name", @"comment_to_user_id", @"comment_content", @"to_look"]];
    
    
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



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
