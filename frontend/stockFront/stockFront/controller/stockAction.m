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

@implementation stockAction
{
    ComTableViewCtrl* comTable;
    LocDatabase* locDatabase;
    NSMutableArray* stockList;
    pullCompleted completed;
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
    
    [comTable.tableView setDelegate:self];
    [comTable.tableView setDataSource:self];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"stockcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        NSLog(@"new cell");
    }
    
    StockInfoModel* stockInfo = [stockList objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
    cell.textLabel.text = stockInfo.stock_name;
    
    if([locDatabase isLookStock:stockInfo]){
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",stockInfo.stock_code, @"看多"];
    }else{
        cell.detailTextLabel.text = stockInfo.stock_code;
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    
    UILabel* priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont fontWithName:fontName size:middleFont];
    
    
    
    if (stockInfo.fluctuate>0) {
        priceLabel.textColor = myred;
        priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(+%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
    }
    
    if(stockInfo.fluctuate<0){
        priceLabel.textColor = mygreen;
        priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
    }
    
    if(stockInfo.fluctuate == 0){
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
    }
    
    CGSize labelSize = [Tools getTextArrange:priceLabel.text maxRect:CGSizeMake(ScreenWidth, 8*minSpace) fontSize:middleFont];
    
    priceLabel.frame = CGRectMake(ScreenWidth - labelSize.width, 0, labelSize.width, labelSize.height);
    
    cell.accessoryView = priceLabel;
    
    
    
    
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:minFont];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    StockInfoModel* stockinfo = [stockList objectAtIndex:indexPath.row];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    
    UIAlertAction *okAction = nil;
    UIAlertController *alertController = nil;
    
    if([locDatabase isLookStock:stockinfo]){
        
        
        NSString* title = [[NSString alloc] initWithFormat:@"取消看多股票%@(%@)", stockinfo.stock_name, stockinfo.stock_code];
        
        alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
        
         okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
             //delete from lookinfo
             //看空股票，发送消息到后台
             
             
             
            if(![locDatabase deleteLookStock:stockinfo]){
                alertMsg(@"操作失败");
            }else{
                alertMsg(@"已取消");
                [tableView reloadData];
            }
        }];

        
    }else{
        
        NSString* title = [[NSString alloc] initWithFormat:@"看多股票%@(%@)", stockinfo.stock_name, stockinfo.stock_code];

        alertController = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
        
        
        okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"add stock to coredata");
            
            //看多股票，发送消息到后台
            
            
            
            if(![locDatabase addLookStock:stockinfo]){
                alertMsg(@"操作失败");
            }else{
                alertMsg(@"已添加");
                [tableView reloadData];
            }
        }];
    }
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [comTable presentViewController:alertController animated:YES completion:nil];
    
}


- (void)tableViewDidAppear:(ComTableViewCtrl *)comTableViewCtrl
{
    
}

- (void)tableViewWillDisappear:(ComTableViewCtrl *)comTableViewCtrl
{
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                        
                        element.price = temp.price;
                        element.fluctuate = temp.fluctuate;
                        element.stock_name = temp.stock_name;
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
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 8*minSpace;
}


- (void)searchAction:(id)sender
{
    StockSearchTableViewCtrl* stockSearch = [[StockSearchTableViewCtrl alloc] initWithStyle:UITableViewStyleGrouped];
    stockSearch.hidesBottomBarWhenPushed = YES;
    [comTable.navigationController pushViewController:stockSearch animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stockList count];
}



@end
