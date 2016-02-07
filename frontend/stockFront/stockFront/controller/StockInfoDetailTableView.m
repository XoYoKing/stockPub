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

@interface StockInfoDetailTableView ()

@end

@implementation StockInfoDetailTableView

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
    
}


- (void)refreshMarketInfo
{
    
    NSDictionary* msg = [[NSDictionary alloc] init];
    [NetworkAPI callApiWithParam:msg childpath:@"/stock/getAllMarketIndexNow" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            
            NSArray* marketData = (NSArray*)[response objectForKey:@"data"];
            
            
            if(marketData!=nil){
                
                for (NSDictionary* element in marketData) {
                    
                    if ([_stockInfoModel.stock_code isEqualToString:[element objectForKey:@"market_code"]]) {
                        StockInfoModel* marketInfoModel = [[StockInfoModel alloc] init];
                        marketInfoModel.stock_code = [element objectForKey:@"market_code"];
                        marketInfoModel.stock_name = [element objectForKey:@"market_name"];
                        marketInfoModel.price = [[element objectForKey:@"market_index_value_now"] floatValue];
                        marketInfoModel.fluctuate_value = [[element objectForKey:@"market_index_fluctuate_value"] floatValue];
                        marketInfoModel.fluctuate = [[element objectForKey:@"market_index_fluctuate"] floatValue];
                        marketInfoModel.open_price = [[element objectForKey:@"market_index_value_open"] floatValue];
                        marketInfoModel.yesterday_price = [[element objectForKey:@"market_index_value_yesterday_close"] floatValue];
                        marketInfoModel.volume = [[element objectForKey:@"market_index_trade_volume"] floatValue]*10000;
                        
                        
                        _stockInfoModel = marketInfoModel;
                    }
                }
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
        
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSDictionary* stockData = (NSDictionary*)[response objectForKey:@"data"];
            
            if(stockData!=nil){
                if([stockData objectForKey:_stockInfoModel.stock_code]){
                    
                    _stockInfoModel = [StockInfoModel yy_modelWithDictionary:[stockData objectForKey:_stockInfoModel.stock_code]];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 6;
    }else if(section == 2){
        return 5;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
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
    }else if(indexPath.section == 1){
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

//            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f万手", _stockInfoModel.amount/10000.0];
        }
        
        if (indexPath.row == 5) {
            cell.textLabel.text = @"5d/20d平均成交额比";
            cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];

//            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%.2f万手", _stockInfoModel.amount/10000.0];
        }
        
        
        return cell;
    }else if(indexPath.section == 2){
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
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [MarketIndexDetailCell cellHeight];
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
    
    if(section == 0){
        label.text = @"";
    }
    if(section == 1){
        label.text = @"今日行情";
    }
    if (section == 2) {
        label.text = @"公司基本面";
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
