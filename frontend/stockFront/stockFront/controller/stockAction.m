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
    cell.detailTextLabel.text = stockInfo.stock_code;
    
    
    
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


- (void)tableViewDidAppear:(ComTableViewCtrl *)comTableViewCtrl
{
    
}

- (void)tableViewWillDisappear:(ComTableViewCtrl *)comTableViewCtrl
{
    
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


- (CGFloat)cellHeight:(UITableView*)tableView indexPath:(NSIndexPath *)indexPath
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
