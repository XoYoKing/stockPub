//
//  SettingCtrl.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "SettingCtrl.h"
#import "StockSearchTableViewCtrl.h"
#import "StockLookInfoModel.h"

#import "macro.h"
#import "returnCode.h"
#import "FaceCellViewTableViewCell.h"
#import "NetworkAPI.h"
#import "AppDelegate.h"
#import <YYModel.h>
#import <Masonry.h>
#import "StockLookTableViewCell.h"
#import "LocDatabase.h"
#import "StockLookDetailTableViewController.h"
#import "StockLookTableView.h"
#import "HisStockLookAction.h"
#import "UserTableView.h"
#import "getFollowUserAction.h"
#import "GetFansAction.h"
#import "UnreadCommentTableView.h"
#import "UnreadCommentStockTableView.h"

@implementation SettingCtrl
{
    NSMutableArray* stockLookList;
    //NSMutableArray* hisStockLookList;
    UserInfoModel* myInfo;
    LocDatabase* locDatabase;
    UserInfoModel* phoneUserInfo;
    BOOL isFollow;
    NSInteger unreadCommentCount;
    NSInteger unreadCommentToStockCount;
    NSInteger unreadFollowCount;
    UILabel *navTitle;
}


typedef enum {
    faceSection,
    followSection,
    lookInfoSection,
    hisLookInfoSection,
    msgSection,
    logout
} section;

- (id)init:(UserInfoModel*)userInfo
{
    if(self = [super initWithStyle:UITableViewStylePlain]){
        myInfo = userInfo;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
        NSLog(@"com table view delloc");
        
        self.view = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.tableView reloadData];
    NSLog(@"viewWillAppear");
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
    if ([myInfo.user_id isEqualToString:phoneUserInfo.user_id]) {
        [self getUnreadCommentCount];
    }
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullDownAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    
    stockLookList = [[NSMutableArray alloc] init];
    //hisStockLookList = [[NSMutableArray alloc] init];
    locDatabase = [AppDelegate getLocDatabase];
    
    phoneUserInfo = [AppDelegate getMyUserInfo];
    
    [self pullDownAction];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == lookInfoSection){
        StockLookInfoModel* model = [stockLookList objectAtIndex:indexPath.row];
        StockLookDetailTableViewController* tableviewCtrl = [[StockLookDetailTableViewController alloc] init];
        tableviewCtrl.stockLookInfoModel = model;
        tableviewCtrl.stocklist = stockLookList;
        tableviewCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tableviewCtrl animated:YES];
    }
    
    if (indexPath.section == hisLookInfoSection) {
        StockLookTableView* stockLookTable = [[StockLookTableView alloc] init:@"历史记录"];
        
        stockLookTable.pullAction = [[HisStockLookAction alloc] init:myInfo.user_id];
        ComTableViewCtrl* comTable = [[ComTableViewCtrl alloc] init:YES allowPullUp:YES initLoading:YES comDelegate:stockLookTable];
        comTable.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:comTable animated:YES];
    }
    
    if (indexPath.section == logout) {
        [self logout];
    }
    
    
    if(indexPath.section == followSection){
        if (indexPath.row == 2) {
            //follow, cancel follow
            if ([locDatabase isFollow:myInfo]) {
                [self cancelFollow];
            }else{
                [self follow];
            }
        }
        
        if(indexPath.row == 0){
            //我关注的人
            getFollowUserAction* getFollowUser = [[getFollowUserAction alloc] init:myInfo.user_id];
            UserTableView* userTable = [[UserTableView alloc] init:@"关注"];
            userTable.pullAction = getFollowUser;
            ComTableViewCtrl* com = [[ComTableViewCtrl alloc] init:YES allowPullUp:YES initLoading:YES comDelegate:userTable];
            com.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:com animated:YES];
        }
        
        if(indexPath.row == 1){
            //关注我的人
            GetFansAction* getFansAction = [[GetFansAction alloc] init:myInfo.user_id];
            UserTableView* userTable = [[UserTableView alloc] init:@"被关注"];
            userTable.pullAction = getFansAction;
            ComTableViewCtrl* com = [[ComTableViewCtrl alloc] init:YES allowPullUp:YES initLoading:YES comDelegate:userTable];
            com.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:com animated:YES];
        }
        
    }
    
    if(indexPath.section == msgSection){
        if (indexPath.row == 0) {
            //未读看多评论
            UnreadCommentTableView* unreadCommentTableView = [[UnreadCommentTableView alloc] initWithStyle:UITableViewStyleGrouped];
            unreadCommentTableView.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:unreadCommentTableView animated:YES];
            
            
        }
        
        if (indexPath.row == 1) {
            //未读个股评论
            UnreadCommentStockTableView* unreadTableview = [[UnreadCommentStockTableView alloc] initWithStyle:UITableViewStyleGrouped];
            unreadTableview.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:unreadTableview animated:YES];

        }
        
    }
}

- (void)follow
{
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[phoneUserInfo.user_id, phoneUserInfo.user_name, myInfo.user_id]
                             forKeys:@[@"user_id", @"user_name", @"followed_user_id"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/followUser" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [locDatabase addFollow:myInfo];
        }else{
            alertMsg(@"未知错误");
        }
        
        
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)cancelFollow
{
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[phoneUserInfo.user_id, myInfo.user_id]
                             forKeys:@[@"user_id", @"followed_user_id"]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    [NetworkAPI callApiWithParam:message childpath:@"/user/cancelFollowUser" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [locDatabase delFollow:myInfo];
        }else{
            alertMsg(@"未知错误");
        }
        
        
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}

- (void)logout
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSDictionary* message = [[NSDictionary alloc]
                                 initWithObjects:@[app.myInfo.user_id]
                                 forKeys:@[@"user_id"]];
        
        [NetworkAPI callApiWithParam:message childpath:@"/user/logout" successed:^(NSDictionary *response) {
            
            if ([[response objectForKey:@"code"] integerValue] == SUCCESS) {
                //清理本地账户信息
                NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
                [mySettingData removeObjectForKey:@"phone"];
                [mySettingData removeObjectForKey:@"password"];
                [mySettingData synchronize];
            }else{
                
            }
            
        } failed:^(NSError *error) {
            
        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.isLogin = false;
            [app backToStartView];
            
        });
    });

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == hisLookInfoSection||section == faceSection||section == followSection) {
        return 0;
    }else{
        return 4*minSpace;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == lookInfoSection){
        return [self getStockSectionView];
    }

    if(section == hisLookInfoSection){
//        //历史看多
//        UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6*minSpace)];
//        sectionView.backgroundColor = [UIColor whiteColor];
//        
//        //股票名称
//        UILabel* label = [[UILabel alloc] init];
//        label.font = [UIFont fontWithName:fontName size:minFont];
//        label.textColor = [UIColor grayColor];
//        label.text = @"历史记录";
//        label.textAlignment = NSTextAlignmentCenter;
//        [sectionView addSubview:label];
//        
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(sectionView.mas_left);
//            make.centerY.mas_equalTo(sectionView.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
//        }];
//        
//        return sectionView;
        return nil;
    }
    
//    if (section == msgSection) {
//        return [self getSectionView:@"消息"];
//    }
    
    return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView == scrollView) {
        if (scrollView.contentOffset.y<0) {
            navTitle.alpha = 0;
        }else{
            navTitle.alpha = scrollView.contentOffset.y/ScreenHeight;
        }
    }
}

- (UIView*)getSectionView:(NSString*)title
{
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6*minSpace)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    //股票名称
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:fontName size:minFont];
    label.textColor = [UIColor grayColor];
    label.text = title;
    [sectionView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionView.mas_left);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    return sectionView;
}

- (UIView*)getStockSectionView
{
    //当前看多
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6*minSpace)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    //股票名称
    UILabel* stockNameLabel = [[UILabel alloc] init];
    stockNameLabel.font = [UIFont fontWithName:fontName size:minFont];
    stockNameLabel.textColor = [UIColor grayColor];
    stockNameLabel.text = @"股票名称";
    stockNameLabel.textAlignment = NSTextAlignmentCenter;
    
    //现价成本
    UILabel* priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont fontWithName:fontName size:minFont];
    priceLabel.textColor = [UIColor grayColor];
    priceLabel.text = @"现价/成本";
    priceLabel.textAlignment = NSTextAlignmentCenter;

    
    //浮动盈亏
    UILabel* yieldLabel = [[UILabel alloc] init];
    yieldLabel.font = [UIFont fontWithName:fontName size:minFont];
    yieldLabel.textColor = [UIColor grayColor];
    yieldLabel.text = @"浮动盈亏";
    yieldLabel.textAlignment = NSTextAlignmentCenter;

    
    [sectionView addSubview:stockNameLabel];
    [sectionView addSubview:priceLabel];
    [sectionView addSubview:yieldLabel];
    
    
    [stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionView.mas_left);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockNameLabel.mas_right);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    [yieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLabel.mas_right);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    return sectionView;

}


- (void)getUserBaseInfo
{
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[myInfo.user_id]
                             forKeys:@[@"user_id"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/userBaseInfo" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            
            NSDictionary* userBaseInfo = (NSDictionary*)[response objectForKey:@"data"];
            if(userBaseInfo!=nil){
                
                myInfo = [UserInfoModel yy_modelWithDictionary:userBaseInfo];
                [navTitle setText:myInfo.user_name];
                navTitle.alpha = 0;
            }
            
        }else{
            alertMsg(@"未知错误");
        }
        
        //[self.refreshControl endRefreshing];
        //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        //[self.refreshControl endRefreshing];
        //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    }];

}

- (void)getUnreadCommentCount
{
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[myInfo.user_id]
                             forKeys:@[@"user_id"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getUnreadCommentCount" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            
            NSDictionary* data = [response objectForKey:@"data"];
            
            unreadCommentCount = [[data objectForKey:@"unreadCommentCount"] integerValue];
            unreadCommentToStockCount = [[data objectForKey:@"unreadCommentToStockCount"] integerValue];
            unreadFollowCount = [[data objectForKey:@"unreadFollowCount"] integerValue];
            
            
            if (unreadCommentToStockCount+unreadCommentCount+unreadFollowCount>0) {
                [[[[[self tabBarController] viewControllers] objectAtIndex:3] tabBarItem] setBadgeValue:[[NSString alloc] initWithFormat:@"%ld", unreadCommentToStockCount+unreadCommentCount+unreadFollowCount]];
                
            }else{
                [[[[[self tabBarController] viewControllers] objectAtIndex:3] tabBarItem] setBadgeValue:nil];
            }
            
        }else{
            alertMsg(@"未知错误");
        }
        
        //[self.refreshControl endRefreshing];
        //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        //[self.refreshControl endRefreshing];
        //self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    }];

}


- (void)getCurStockLook
{
    //获取当前看多股票详情
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[myInfo.user_id]
                             forKeys:@[@"user_id"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/getLookInfoByUser" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [stockLookList removeAllObjects];
            
            NSArray* stockLookInfoArray = (NSArray*)[response objectForKey:@"data"];
            if(stockLookInfoArray!=nil){
                for (NSDictionary* element in stockLookInfoArray) {
                    StockLookInfoModel* temp = [StockLookInfoModel yy_modelWithDictionary:element];
                    [stockLookList addObject:temp];
                    StockInfoModel* stockInfoModel = [[StockInfoModel alloc] init];
                    stockInfoModel.stock_code = temp.stock_code;
                    if([myInfo.user_id isEqualToString:phoneUserInfo.user_id]){
                        [locDatabase addLookStock:stockInfoModel];
                    }
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

- (void)pullDownAction
{
    
    [self getUserBaseInfo];
    [self getCurStockLook];
    if ([myInfo.user_id isEqualToString:phoneUserInfo.user_id]) {
        [self getUnreadCommentCount];
    }
    
}

- (void)searchAction:(id)sender
{
    //[self.navigationController pushViewController:[[StockSearchTableViewCtrl alloc] init] animated:YES];

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == faceSection) {
        
        static NSString* cellIdentifier = @"facecell";
        FaceCellViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[FaceCellViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        [cell configureCell:myInfo];
        
        return cell;
    }
    
    
    if(indexPath.section == followSection){
        static NSString* cellIdentifier = @"followcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        if(indexPath.row == 0){
            
            if([myInfo.user_id isEqualToString:phoneUserInfo.user_id]){
                cell.textLabel.text = @"我关注的人";
            }else{
                cell.textLabel.text = @"ta关注的人";
            }
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%ld", myInfo.user_follow_count];
        }
        
        if(indexPath.row == 1){
            if([myInfo.user_id isEqualToString:phoneUserInfo.user_id]){
                cell.textLabel.text = @"关注我的人";

            }else{
                cell.textLabel.text = @"关注ta的人";

            }

            
            
            if(unreadFollowCount != 0){
                
                UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3*minSpace, 3*minSpace)];
                numberLabel.backgroundColor = [UIColor redColor];
                numberLabel.text = [[NSString alloc] initWithFormat:@"%ld", unreadFollowCount];
                numberLabel.textColor = [UIColor whiteColor];
                numberLabel.layer.cornerRadius = 3*minSpace/2;
                numberLabel.font = [UIFont fontWithName:fontName size:minFont];
                numberLabel.textAlignment = NSTextAlignmentCenter;
                numberLabel.layer.masksToBounds = YES;
                cell.accessoryView = numberLabel;
                
            }else{
                cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%ld", myInfo.user_fans_count];
                cell.accessoryView = nil;
            }
            
        }
        
        if(indexPath.row == 2){
            if([locDatabase isFollow:myInfo]){
                cell.textLabel.text = @"取消关注ta";
            }else{
                cell.textLabel.text = @"关注ta";
            }
        }
        
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if(indexPath.section == lookInfoSection){
        
        //当前看多股票收益
        static NSString* cellIdentifier = @"stockLook";
        StockLookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[StockLookTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        [cell configureCell:[stockLookList objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    if(indexPath.section == hisLookInfoSection){
        
        //历史记录
        static NSString* cellIdentifier = @"hisStockLook";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        cell.textLabel.text = @"更多历史记录";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    if (indexPath.section == logout) {
        //登出
        static NSString* cellIdentifier = @"logoutcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    if (indexPath.section == msgSection) {
        //看多评论
        if(indexPath.row == 0){
            static NSString* cellIdentifier = @"msgcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                NSLog(@"new cell");
            }
            
            cell.textLabel.text = @"看多评论";
            
            
            
            if(unreadCommentCount != 0){
                
                UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3*minSpace, 3*minSpace)];
                numberLabel.backgroundColor = [UIColor redColor];
                numberLabel.text = [[NSString alloc] initWithFormat:@"%ld", unreadCommentCount];
                numberLabel.textColor = [UIColor whiteColor];
                numberLabel.layer.cornerRadius = 3*minSpace/2;
                numberLabel.font = [UIFont fontWithName:fontName size:minFont];
                numberLabel.textAlignment = NSTextAlignmentCenter;
                numberLabel.layer.masksToBounds = YES;
                cell.accessoryView = numberLabel;
                
            }else{
                cell.detailTextLabel.text = @"";
                cell.accessoryView = nil;
            }

            cell.textLabel.textColor = [UIColor grayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        
        //个股评论
        if(indexPath.row == 1){
            static NSString* cellIdentifier = @"msgcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell==nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                NSLog(@"new cell");
            }
            
            cell.textLabel.text = @"个股评论";
            
            
            
            if(unreadCommentToStockCount != 0){
                
                UILabel* numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 3*minSpace, 3*minSpace)];
                numberLabel.backgroundColor = [UIColor redColor];
                numberLabel.text = [[NSString alloc] initWithFormat:@"%ld", unreadCommentToStockCount];
                numberLabel.textColor = [UIColor whiteColor];
                numberLabel.layer.cornerRadius = 3*minSpace/2;
                numberLabel.font = [UIFont fontWithName:fontName size:minFont];
                numberLabel.textAlignment = NSTextAlignmentCenter;
                numberLabel.layer.masksToBounds = YES;
                cell.accessoryView = numberLabel;
                
            }else{
                cell.detailTextLabel.text = @"";
                cell.accessoryView = nil;
            }
//
            cell.textLabel.textColor = [UIColor grayColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }

        
    }
    
    return nil;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == lookInfoSection) {
        return @"当前看多";
    }
    
//    if (section == hisLookInfoSection){
//        return @"历史记录";
//    }
    
    if (section == msgSection) {
        return @"";
    }
    
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == faceSection){
        return [FaceCellViewTableViewCell cellHeight];
    }
    
    if(indexPath.section == followSection){
        return 6*minSpace;
    }
    
    if(indexPath.section == lookInfoSection||indexPath.section == hisLookInfoSection){
        return 8*minSpace;
    }
    
    if (indexPath.section == logout) {
        return 8*minSpace;
    }
    
    if(indexPath.section == msgSection){
        return 6*minSpace;
    }
    
    return 6*minSpace;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == faceSection) {
        return 1;
    }
    
    if (section == followSection) {
        if([phoneUserInfo.user_id isEqualToString:myInfo.user_id]){
            return 2;
        }else{
            return 3;
        }
    }
    
    if(section == lookInfoSection){
        return [stockLookList count];
    }
    
    if(section == hisLookInfoSection){
        return 1;
    }
    
    if(section == logout){
        return 1;
    }
    
    if (section == msgSection) {
        return 2;
    }
    
    return 0;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    
    if([myInfo.user_id isEqualToString:userInfo.user_id]){
        return 6;
    }else{
        return 4;
    }
}


@end
