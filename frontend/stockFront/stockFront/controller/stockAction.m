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
}



- (UITableViewCell*)generateCell:(UITableView*)tableview indexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"stockcell";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        NSLog(@"new cell");
    }
    
    StockInfoModel* stockInfo = [stockList objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:fontName size:middleFont];
    cell.textLabel.text = stockInfo.stock_name;
    cell.detailTextLabel.text = stockInfo.stock_code;
    UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - ScreenWidth/2, 0, ScreenWidth/2, 8*minSpace)];
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
    
    
    cell.accessoryView = priceLabel;
    
    
    
    
    cell.detailTextLabel.font = [UIFont fontWithName:fontName size:minFont];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;

}


- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    completed = completedBlock;
    stockList = [locDatabase getStocklist];

    
    //[self getFollowList:[[NSDate date] timeIntervalSince1970] handleAction:@selector(getFollowListSuccess:)];
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
