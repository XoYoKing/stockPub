//
//  StockInfoDetailTableView.m
//  stockFront
//
//  Created by wang jam on 2/7/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockInfoDetailTableView.h"
#import "MarketIndexDetailCell.h"
#import "macro.h"
#import <Masonry.h>
#import "NetworkAPI.h"
#import "macro.h"
#import "returnCode.h"
#import <YYModel.h>
#import "AppDelegate.h"
#import "LocDatabase.h"
#import <MBProgressHUD.h>
#import "UserInfoModel.h"
#import "KLineCell.h"
#import "StockCommentTableView.h"
#import "getCommentToStockAction.h"
#import <UMSocial.h>
#import "HXEasyCustomShareView.h"
#import "WXApi.h"

@interface StockInfoDetailTableView ()
{
    CGFloat fiveAvVolume;
    CGFloat twentyAvVolume;
    UILabel *navTitle;
}
@end

@implementation StockInfoDetailTableView

typedef enum {
    nowSection,
    klineSection,
    marketInfoSection,
    baseSection
} StockInfoDetailSection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullDownAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    [self showRightItem];
    
    
    [self getStock20AvgVolume];
    [self getStock5AvgVolume];
    [self pullDownAction];
    
    
    
    navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    navTitle.alpha = 0;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y<0) {
            navTitle.alpha = 0;
        }else{
            navTitle.alpha = scrollView.contentOffset.y/ScreenHeight;
        }
    }
}



- (void)getStock20AvgVolume
{
    
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_stockInfoModel.stock_code,[[NSNumber alloc] initWithInteger:20]]
                             forKeys:@[@"stock_code", @"day"]];
    NSString* childpath = @"";
    if(_ismarket){
        childpath = @"/stock/getMarketAvgVolume";
    }else{
        childpath = @"/stock/getAvgVolume";
    }
    
    
    [NetworkAPI callApiWithParam:message childpath:childpath successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            if((NSNull*)[response objectForKey:@"data"] == [NSNull null]){
                return;
            }
            
            twentyAvVolume = [[response objectForKey:@"data"] floatValue];
            [self.tableView reloadData];
            
        }else{
            alertMsg(@"未知错误");
        }
        
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];

}

- (void)getStock5AvgVolume
{
    NSString* childpath = @"";
    if(_ismarket){
        childpath = @"/stock/getMarketAvgVolume";
    }else{
        childpath = @"/stock/getAvgVolume";
    }
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_stockInfoModel.stock_code,[[NSNumber alloc] initWithInteger:5]]
                             forKeys:@[@"stock_code", @"day"]];
    
    [NetworkAPI callApiWithParam:message childpath:childpath successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            if((NSNull*)[response objectForKey:@"data"] == [NSNull null]){
                return;
            }

            
            fiveAvVolume = [[response objectForKey:@"data"] floatValue];
            [self.tableView reloadData];

        }else{
            alertMsg(@"未知错误");
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
}

- (void)showRightItem
{
    if(_ismarket == false){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more:)];

    }
    
    if(_ismarket == true){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(commentAction:)];
    }

}

- (void)more:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    LocDatabase* loc = [AppDelegate getLocDatabase];
    
    if([loc isLookStock:_stockInfoModel]){
        UIAlertAction* lookAction= [UIAlertAction actionWithTitle:@"取消看多" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self cancelLook:nil];
        }];
        [alertController addAction:lookAction];
    }else{
        UIAlertAction* lookAction= [UIAlertAction actionWithTitle:@"看多" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self addlook:nil];
        }];
        [alertController addAction:lookAction];
    }
    
    if ([loc isFollowStock:_stockInfoModel]) {
        UIAlertAction* chooseAction= [UIAlertAction actionWithTitle:@"取消自选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self delstock:_stockInfoModel];
            
        }];
        [alertController addAction:chooseAction];

    }else{
        UIAlertAction* chooseAction= [UIAlertAction actionWithTitle:@"添加到自选" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self addstock:_stockInfoModel];
            
        }];
        [alertController addAction:chooseAction];

    }
    
    //评论
    UIAlertAction* chooseAction= [UIAlertAction actionWithTitle:@"评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self commentAction:nil];
        
    }];
    [alertController addAction:chooseAction];
    
    
    //分享
    UIAlertAction* shareAction= [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:@"507fcab25270157b37000010"
//                                          shareText:@"你要分享的文字"
//                                         shareImage:[UIImage imageNamed:@"me@2x.png"]
//                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, nil]
//                                           delegate:self];
        
        [self addWeixinShareView];
        
    }];
    [alertController addAction:shareAction];
    
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


/**
 *  仿微信分享界面
 */
- (void)addWeixinShareView {
    NSArray *shareAry = @[@{@"image":@"Action_Share",
                            @"title":@"发送给朋友"},
                          @{@"image":@"Action_Moments",
                            @"title":@"朋友圈"},
                          @{@"image":@"Action_MyFavAdd",
                            @"title":@"收藏"}];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, headerView.frame.size.width, 11)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:99/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11];
    label.text = @"网页由 mp.weixin.qq.com 提供";
    [headerView addSubview:label];
    
    HXEasyCustomShareView *shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
    shareView.headerView = headerView;
    float height = [shareView getBoderViewHeight:shareAry firstCount:6];
    shareView.boderView.frame = CGRectMake(0, 0, shareView.frame.size.width, height);
    [shareView setShareAry:shareAry delegate:self];
    shareView.middleLineLabel.frame = CGRectMake(10, shareView.middleLineLabel.frame.origin.y, shareView.frame.size.width-20, shareView.middleLineLabel.frame.size.height);
    shareView.showsHorizontalScrollIndicator = NO;
    [self.navigationController.view addSubview:shareView];
}


-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


- (void)delstock:(StockInfoModel*)stockInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[userInfo.user_id,
                                               stockInfo.stock_code]
                             forKeys:@[@"user_id", @"stock_code"]];
    
    LocDatabase* loc = [AppDelegate getLocDatabase];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/delstock" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        if(code == SUCCESS){
            
            if([loc deleteStock:stockInfo]){
                alertMsg(@"完成");

            }else{
                alertMsg(@"本地数据库错误");
            }
            
            [self.tableView reloadData];
        }else{
            alertMsg(@"未知错误");
        }
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
}

- (void)addstock:(StockInfoModel*)stockInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[userInfo.user_id,
                                               stockInfo.stock_code]
                             forKeys:@[@"user_id", @"stock_code"]];
    
    LocDatabase* loc = [AppDelegate getLocDatabase];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/addstock" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        if(code == SUCCESS){
            
            if([loc addStock:stockInfo]){
                alertMsg(@"完成");
            }else{
                alertMsg(@"本地数据库错误");
            }
            
            [self.tableView reloadData];
        }else{
            alertMsg(@"未知错误");
        }
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
}


- (void)commentAction:(id)sender
{
    getCommentToStockAction* pullAction = [[getCommentToStockAction alloc] initWithStockCode:_stockInfoModel.stock_code];
    
    StockCommentTableView* stockCommentTableview = [[StockCommentTableView alloc] initWithStock:_stockInfoModel pullAction:pullAction];
    
    ComTableViewCtrl* comTable = [[ComTableViewCtrl alloc] init:YES allowPullUp:YES initLoading:YES comDelegate:stockCommentTableview];
    
    [self.navigationController pushViewController:comTable animated:YES];
}


- (void)addlook:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    NSDictionary* message = [[NSDictionary alloc]
                                             initWithObjects:@[userInfo.user_id,
                                                               userInfo.user_name, _stockInfoModel.stock_code, _stockInfoModel.stock_name,
                                                               [[NSNumber alloc] initWithInteger:1]]
                                             forKeys:@[@"user_id", @"user_name", @"stock_code", @"stock_name", @"look_direct"]];
    
    LocDatabase* locDatabase = [AppDelegate getLocDatabase];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/addlook" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        if(code == SUCCESS){
            
            if(![locDatabase addLookStock:_stockInfoModel]){
                alertMsg(@"操作失败");
            }else{
                //alertMsg(@"已添加");
                alertMsg(@"完成");
            }
            
            [self.tableView reloadData];
        }else if(code == LOOK_STOCK_EXIST){
            alertMsg(@"不能重复添加");
        }else if(code == LOOK_STOCK_COUNT_OVER){
            alertMsg(@"当前看多股票不能超过5支");
        }else{
            alertMsg(@"未知错误");
        }
        
        [self showRightItem];
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
}

- (void)cancelLook:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
    
    
    
    NSDictionary* message = [[NSDictionary alloc]
                                             initWithObjects:@[userInfo.user_id,
                                                               userInfo.user_name, _stockInfoModel.stock_code, _stockInfoModel.stock_name]
                                             forKeys:@[@"user_id", @"user_name", @"stock_code", @"stock_name"]];
    
    LocDatabase* locDatabase = [AppDelegate getLocDatabase];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/dellook" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            if(![locDatabase deleteLookStock:_stockInfoModel]){
                alertMsg(@"操作失败");
            }else{
                //alertMsg(@"已删除");
                alertMsg(@"完成");
            }
            
            [self.tableView reloadData];
            [self showRightItem];
            
        }else if(code == LOOK_DEL_NOT_TODAY){
            alertMsg(@"当日看多股票不可当日取消");
        }else{
            alertMsg(@"未知错误");
        }

        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];
    
}

- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title
{
    NSLog(@"%@", title);
    [shareView tappedCancel];
    
//    UserInfoModel* user = [AppDelegate getMyUserInfo];
    
    if([title isEqualToString:@"朋友圈"]){
        NSString* title = [[NSString alloc] initWithFormat:@"%@%@(%@),%.2f(%.2f%%)",  @"分享了", _stockInfoModel.stock_name, _stockInfoModel.stock_code, _stockInfoModel.price, _stockInfoModel.fluctuate];
        [self sendLinkContent:title scene:WXSceneTimeline];
    }
    
    
    if([title isEqualToString:@"发送给朋友"]){
        NSString* title = [[NSString alloc] initWithFormat:@"%@%@(%@),%.2f(%.2f%%)", @"分享了", _stockInfoModel.stock_name, _stockInfoModel.stock_code, _stockInfoModel.price, _stockInfoModel.fluctuate];
        [self sendLinkContent:title scene:WXSceneSession];
    }
}

- (void)sendLinkContent:(NSString*)title  scene:(int)scene {
    UIImage *thumbImage = [UIImage imageNamed:@"180-1px.png"];
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = title;
    [message setThumbImage:thumbImage];
    WXWebpageObject* webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = @"https://itunes.apple.com/cn/app/lan-ren-gu-piao/id1071644462?l=en&mt=8";
    message.mediaObject = webpageObject;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


- (void)refreshMarketInfo
{
    
    
    NSDictionary* msg = [[NSDictionary alloc] initWithObjects:@[_stockInfoModel.stock_code] forKeys:@[@"stock_code"]];
    
    
    [NetworkAPI callApiWithParam:msg childpath:@"/stock/getAllMarketIndexNowByCode" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            
            NSDictionary* element = (NSDictionary*)[response objectForKey:@"data"];
            
            
            if(element!=nil){
                
                StockInfoModel* marketInfoModel = [[StockInfoModel alloc] init];
                marketInfoModel.stock_code = [element objectForKey:@"market_code"];
                marketInfoModel.stock_name = [element objectForKey:@"market_name"];
                marketInfoModel.price = [[element objectForKey:@"market_index_value_now"] floatValue];
                marketInfoModel.fluctuate_value = [[element objectForKey:@"market_index_fluctuate_value"] floatValue];
                marketInfoModel.fluctuate = [[element objectForKey:@"market_index_fluctuate"] floatValue];
                marketInfoModel.open_price = [[element objectForKey:@"market_index_value_open"] floatValue];
                marketInfoModel.yesterday_price = [[element objectForKey:@"market_index_value_yesterday_close"] floatValue];
                marketInfoModel.volume = [[element objectForKey:@"market_index_trade_volume"] floatValue];
                marketInfoModel.amount = [[element objectForKey:@"market_index_trade_amount"] floatValue];
                marketInfoModel.date = [element objectForKey:@"market_index_date"];
                marketInfoModel.time = [element objectForKey:@"market_index_time"];
                
                
                _stockInfoModel = marketInfoModel;
                [navTitle setText:_stockInfoModel.stock_name];
                navTitle.alpha = 0;

                [self.refreshControl endRefreshing];
                self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
                [self.tableView reloadData];
            }
            
        }else{
            [self.refreshControl endRefreshing];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
            [self.tableView reloadData];
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        [Tools AlertBigMsg:@"网络问题"];
    }];
    
}

- (void)refreshStock
{
    NSMutableArray* stockCodeArray = [[NSMutableArray alloc] init];
    [stockCodeArray addObject:_stockInfoModel.stock_code];
    
    if([stockCodeArray  count] == 1){
        [stockCodeArray addObject:@"0"];
        //单条后台asyn each 不支持
    }
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[stockCodeArray]
                             forKeys:@[@"stocklist"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/getStockListInfo" successed:^(NSDictionary *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSDictionary* stockData = (NSDictionary*)[response objectForKey:@"data"];
            
            if(stockData!=nil){
                if([stockData objectForKey:_stockInfoModel.stock_code]){
                    
                    _stockInfoModel = [StockInfoModel yy_modelWithDictionary:[stockData objectForKey:_stockInfoModel.stock_code]];
                    [navTitle setText:_stockInfoModel.stock_name];
                    navTitle.alpha = 0;
                }
                
                [self.refreshControl endRefreshing];
                self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
                [self.tableView reloadData];
            }
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
            [self.refreshControl endRefreshing];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
            [self.tableView reloadData];
            
        }
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Tools AlertBigMsg:@"网络问题"];
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
    }];

}


- (void)pullDownAction
{
    if(_ismarket == false){
        [self refreshStock];
    }else{
        [self refreshMarketInfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == nowSection) {
        return 1;
    }else if(section == klineSection){
        return 1;
    }else if(section == marketInfoSection){
        return 6;
    }else if(section == baseSection){
        return 5;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == nowSection){
        static NSString* cellIdentifier = @"mainCell";
        MarketIndexDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[MarketIndexDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        [cell configureCell:_stockInfoModel];
        return cell;
    }else if(indexPath.section == marketInfoSection){
        static NSString* cellIdentifier = @"marketInfoCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        cell.textLabel.font = [UIFont fontWithName:fontName size:middleFont];
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:middleFont];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"今开";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f", _stockInfoModel.open_price];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"昨收";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f", _stockInfoModel.yesterday_price];
        }

        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"成交额";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f亿", _stockInfoModel.volume/10000.0];
        }

        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"成交量";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f万手", _stockInfoModel.amount/10000.0];
        }

        if (indexPath.row == 4) {
            cell.textLabel.text = @"1d/5d平均成交额比";
            cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f%%", 100*_stockInfoModel.volume/fiveAvVolume];
            
            
//            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f万手", _stockInfoModel.amount/10000.0];
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"5d/20d平均成交额比";
            cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];

//            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f万手", _stockInfoModel.amount/10000.0];
            
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f%%", 100*fiveAvVolume/twentyAvVolume];
        }
        
        
        return cell;
    }else if(indexPath.section == baseSection){
        static NSString* cellIdentifier = @"baseInfoCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        cell.textLabel.font = [UIFont fontWithName:fontName size:middleFont];
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:middleFont];

        if (indexPath.row == 0) {
            cell.textLabel.text = @"总市值";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f亿", _stockInfoModel.marketValue];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"流通市值";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f亿", _stockInfoModel.flowMarketValue];
        }
        
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"市盈率";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f", _stockInfoModel.priceearning];
        }
        
        
        if (indexPath.row == 3) {
            cell.textLabel.text = @"市净率";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f", _stockInfoModel.pb];
        }
        
        if (indexPath.row == 4) {
            cell.textLabel.text = @"净资产收益率";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f%%", 100*_stockInfoModel.pb/_stockInfoModel.priceearning];
        }
        
        return cell;
    }else if(indexPath.section == klineSection){
        
        static NSString* cellIdentifier = @"klineCell";
        KLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[KLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        if(_ismarket == true){
            _stockInfoModel.is_market = 1;
        }else{
            _stockInfoModel.is_market = 0;
        }
        
        [cell configureCell:_stockInfoModel];
        return cell;

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == nowSection){
        return [MarketIndexDetailCell cellHeight];
    }else if(indexPath.section == klineSection){
        
        return [KLineCell cellHeight];
    }else{
        return 8*minSpace;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 6*minSpace;
    }
    
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6*minSpace)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:fontName size:minFont];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [sectionView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionView.mas_left);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    if(section == nowSection){
        label.text = @"";
    }
    if(section == marketInfoSection){
        label.text = @"今日行情";
    }
    if (section == baseSection) {
        label.text = @"基本面";
    }
    if (section == klineSection) {
        label.text = @"走势图";
    }
    return sectionView;
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
