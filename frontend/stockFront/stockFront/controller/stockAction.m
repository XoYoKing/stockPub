//
//  stockAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "stockAction.h"
#import "macro.h"
#import "StockSearchTableViewCtrl.h"
#import "LocDatabase.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "NetworkAPI.h"
#import "returnCode.h"
#import <YYModel.h>
#import "StockActionTableViewCell.h"
#import <Masonry.h>
#import "StockInfoDetailTableView.h"

@implementation stockAction
{
    ComTableViewCtrl* comTable;
    LocDatabase* locDatabase;
    NSMutableArray* stockList;
    NSMutableArray* marketIndexList;
    pullCompleted completed;
    NSTimer* timer;
}

- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"自选"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    comTableViewCtrl.navigationItem.titleView = navTitle;
    comTableViewCtrl.view.backgroundColor = [UIColor whiteColor];
    
    comTableViewCtrl.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    comTable = comTableViewCtrl;
    
    
    UserInfoModel* myInfo = [AppDelegate getMyUserInfo];
    locDatabase = [[LocDatabase alloc] init];
    if(![locDatabase connectToDatabase:myInfo.user_id]){
        [Tools AlertBigMsg:@"本地数据库错误"];
        return;
    }
    
    stockList = [locDatabase getStocklist];
    marketIndexList = [[NSMutableArray alloc] init];
    
    [comTable.tableView setDelegate:self];
    [comTable.tableView setDataSource:self];
    
    
}


- (void)refreshAll
{
    [self refreshMarketInfo];
    [self refreshStockInfo];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        static NSString* cellIdentifier = @"stockcell";
        StockActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[StockActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        StockInfoModel* stockInfo = [stockList objectAtIndex:indexPath.row];
        [cell configureCell:stockInfo];
        
        return cell;
    }
    
    if(indexPath.section == 0){
        //大盘指数
        static NSString* marketCellIdentifier = @"marketCellIdentifier";
        StockActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:marketCellIdentifier];
        if (cell==nil) {
            cell = [[StockActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:marketCellIdentifier];
            NSLog(@"new cell");
        }
        
        StockInfoModel* stockInfo = [marketIndexList objectAtIndex:indexPath.row];
        [cell configureCell:stockInfo];
        
        return cell;
        
    }

    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        StockInfoModel* stockinfo = [marketIndexList objectAtIndex:indexPath.row];
        StockInfoDetailTableView* detail = [[StockInfoDetailTableView alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.ismarket = true;
        detail.stockInfoModel = stockinfo;
        [comTable.navigationController pushViewController:detail animated:YES];
        
    }
    
    if (indexPath.section == 1) {
        StockInfoModel* stockinfo = [stockList objectAtIndex:indexPath.row];
        StockInfoDetailTableView* detail = [[StockInfoDetailTableView alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.ismarket = false;
        detail.stockInfoModel = stockinfo;
        [comTable.navigationController pushViewController:detail animated:YES];
    }
    
    
//    if(indexPath.section == 1){
//        StockInfoModel* stockinfo = [stockList objectAtIndex:indexPath.row];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            ;
//        }];
//        
//        UIAlertAction *okAction = nil;
//        UIAlertController *alertController = nil;
//        
//        if([locDatabase isLookStock:stockinfo]){
//            
//            
//            NSString* title = [[NSString alloc] initWithFormat:@"取消看多股票%@(%@)", stockinfo.stock_name, stockinfo.stock_code];
//            
//            alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
//            
//            okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                //delete from lookinfo
//                
//                [MBProgressHUD showHUDAddedTo:comTable.view animated:YES];
//                
//                
//                UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
//                NSDictionary* message = [[NSDictionary alloc]
//                                         initWithObjects:@[userInfo.user_id,
//                                                           userInfo.user_name, stockinfo.stock_code, stockinfo.stock_name]
//                                         forKeys:@[@"user_id", @"user_name", @"stock_code", @"stock_name"]];
//                
//                [NetworkAPI callApiWithParam:message childpath:@"/stock/dellook" successed:^(NSDictionary *response) {
//                    [MBProgressHUD hideHUDForView:comTable.view animated:YES];
//                    
//                    
//                    NSInteger code = [[response objectForKey:@"code"] integerValue];
//                    
//                    if(code == SUCCESS){
//                        
//                        if(![locDatabase deleteLookStock:stockinfo]){
//                            alertMsg(@"操作失败");
//                        }else{
//                            //alertMsg(@"已删除");
//                        }
//                        
//                        [tableView reloadData];
//                    }else{
//                        alertMsg(@"未知错误");
//                    }
//                    
//                    
//                } failed:^(NSError *error) {
//                    [MBProgressHUD hideHUDForView:comTable.view animated:YES];
//                    alertMsg(@"网络问题");
//                }];
//            }];
//            
//            
//        }else{
//            
//            NSString* title = [[NSString alloc] initWithFormat:@"看多股票%@(%@)", stockinfo.stock_name, stockinfo.stock_code];
//            
//            alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
//            
//            
//            okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSLog(@"add stock to coredata");
//                
//                //看多股票，发送消息到后台
//                [MBProgressHUD showHUDAddedTo:comTable.view animated:YES];
//                
//                
//                UserInfoModel* userInfo = [AppDelegate getMyUserInfo];
//                NSDictionary* message = [[NSDictionary alloc]
//                                         initWithObjects:@[userInfo.user_id,
//                                                           userInfo.user_name, stockinfo.stock_code, stockinfo.stock_name,
//                                                           [[NSNumber alloc] initWithInteger:1]]
//                                         forKeys:@[@"user_id", @"user_name", @"stock_code", @"stock_name", @"look_direct"]];
//                
//                [NetworkAPI callApiWithParam:message childpath:@"/stock/addlook" successed:^(NSDictionary *response) {
//                    [MBProgressHUD hideHUDForView:comTable.view animated:YES];
//                    
//                    
//                    NSInteger code = [[response objectForKey:@"code"] integerValue];
//                    
//                    if(code == SUCCESS){
//                        
//                        if(![locDatabase addLookStock:stockinfo]){
//                            alertMsg(@"操作失败");
//                        }else{
//                            //alertMsg(@"已添加");
//                        }
//                        
//                        [tableView reloadData];
//                    }else if(code == LOOK_STOCK_EXIST){
//                        alertMsg(@"不能重复添加");
//                    }else if(code == LOOK_STOCK_COUNT_OVER){
//                        alertMsg(@"当前看多股票不能超过5支");
//                    }else{
//                        alertMsg(@"未知错误");
//                    }
//                } failed:^(NSError *error) {
//                    [MBProgressHUD hideHUDForView:comTable.view animated:YES];
//                    alertMsg(@"网络问题");
//                }];
//                
//            }];
//        }
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [comTable presentViewController:alertController animated:YES completion:nil];
//    }
}


- (void)tableViewDidAppear:(ComTableViewCtrl*)comTableViewCtrl;
{
    NSLog(@"viewDidAppear");
    [self refreshStockInfo];
    [self refreshMarketInfo];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(refreshAll) userInfo:nil repeats:YES];
}


- (void)tableViewDidDisappear:(ComTableViewCtrl *)comTableViewCtrl
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer invalidate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    [self refreshStockInfo];
    [self refreshMarketInfo];
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            
            
            StockInfoModel* stockInfo = [stockList objectAtIndex:indexPath.row];
            if ([locDatabase deleteStock:stockInfo]) {
                [stockList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [Tools AlertBigMsg:@"删除失败"];
            }
            
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    if(indexPath.section == 0){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
                [marketIndexList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}


- (void)refreshMarketInfo
{
    
    NSDictionary* msg = [[NSDictionary alloc] init];
    [NetworkAPI callApiWithParam:msg childpath:@"/stock/getAllMarketIndexNow" successed:^(NSDictionary *response) {
        
        completed();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [marketIndexList removeAllObjects];
            
            NSArray* marketData = (NSArray*)[response objectForKey:@"data"];
            
            
            
            if(marketData!=nil){
                
                for (NSDictionary* element in marketData) {
                    StockInfoModel* marketInfoModel = [[StockInfoModel alloc] init];
                    marketInfoModel.stock_code = [element objectForKey:@"market_code"];
                    marketInfoModel.stock_name = [element objectForKey:@"market_name"];
                    marketInfoModel.price = [[element objectForKey:@"market_index_value_now"] floatValue];
                    marketInfoModel.fluctuate_value = [[element objectForKey:@"market_index_fluctuate_value"] floatValue];
                    marketInfoModel.fluctuate = [[element objectForKey:@"market_index_fluctuate"] floatValue];
                    marketInfoModel.fluctuate_value = [[element objectForKey:@"market_index_fluctuate_value"] floatValue];
                    
                    marketInfoModel.open_price = [[element objectForKey:@"market_index_value_open"] floatValue];
                    marketInfoModel.yesterday_price = [[element objectForKey:@"market_index_value_yesterday_close"] floatValue];
                    marketInfoModel.volume = [[element objectForKey:@"market_index_trade_volume"] floatValue];
                    marketInfoModel.amount = [[element objectForKey:@"market_index_trade_amount"] floatValue];

                    
                    [marketIndexList addObject:marketInfoModel];
                }
                
                [comTable.tableView reloadData];
            }
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
        completed();
    }];

}

- (void)refreshStockInfo
{
    stockList = [locDatabase getStocklist];
    
    
    //[self getFollowList:[[NSDate date] timeIntervalSince1970] handleAction:@selector(getFollowListSuccess:)];
    
    //获取股票详情
    
    NSMutableArray* stockCodeArray = [[NSMutableArray alloc] init];
    for (StockInfoModel* element in stockList) {
        [stockCodeArray addObject:element.stock_code];
    }
    
    if([stockCodeArray count] == 0){
        completed();
        return;
    }
    
    if([stockCodeArray  count] == 1){
        [stockCodeArray addObject:@"0"];
        //单条后台asyn each 不支持
    }
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[stockCodeArray]
                             forKeys:@[@"stocklist"]];
    
    

    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/getStockListInfo" successed:^(NSDictionary *response) {
        
        completed();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSDictionary* stockData = (NSDictionary*)[response objectForKey:@"data"];
            
            
            
            if(stockData!=nil){
                for (StockInfoModel* element in stockList) {
                    if([stockData objectForKey:element.stock_code]){
                        
                        StockInfoModel* temp = [StockInfoModel yy_modelWithDictionary:[stockData objectForKey:element.stock_code]];
                        element.fluctuate_value = temp.fluctuate_value;
                        element.price = temp.price;
                        element.fluctuate = temp.fluctuate;
                        element.stock_name = temp.stock_name;
                        element.open_price = temp.open_price;
                        element.yesterday_price = temp.yesterday_price;
                        element.volume = temp.volume;
                        element.amount = temp.amount;
                        element.marketValue = temp.marketValue;
                        element.flowMarketValue = temp.flowMarketValue;
                        element.priceearning = temp.priceearning;
                        element.pb = temp.pb;
                    }
                }
                
                [comTable.tableView reloadData];
            }
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
        completed();
    }];

}

- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    completed = completedBlock;
    [self refreshStockInfo];
    [self refreshMarketInfo];
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
    
    if(section == 0){
        label.text = @"大盘指数";
    }
    if(section == 1){
        label.text = @"自选股票";
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6*minSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StockActionTableViewCell cellHeight];
}


- (void)searchAction:(id)sender
{
    StockSearchTableViewCtrl* stockSearch = [[StockSearchTableViewCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    stockSearch.hidesBottomBarWhenPushed = YES;
    [comTable.navigationController pushViewController:stockSearch animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [marketIndexList count];
    }
    
    if(section == 1){
        return [stockList count];
    }
    return 0;
}



@end
