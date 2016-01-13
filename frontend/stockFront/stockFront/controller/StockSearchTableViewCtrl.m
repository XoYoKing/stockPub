//
//  StockSearchTableViewCtrl.m
//  stockFront
//
//  Created by wang jam on 1/11/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockSearchTableViewCtrl.h"
#import "macro.h"
#import "NetworkAPI.h"
#import "returnCode.h"
#import "Tools.h"
#import "StockInfoModel.h"
#import <YYModel.h>
#import <Masonry.h>

@implementation StockSearchTableViewCtrl
{
    NSMutableArray* stockList;
    UITextField* stockSearchTextField;
}

- (void)viewDidLoad
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:@"搜索"];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    stockSearchTextField = [[UITextField alloc] init];
    stockSearchTextField.frame = CGRectMake(0, 0, ScreenWidth - 4*minSpace, 6*minSpace);
    stockSearchTextField.textAlignment = NSTextAlignmentLeft;
    stockSearchTextField.font = [UIFont fontWithName:fontName size:minFont];
    stockSearchTextField.placeholder = @"请输入股票代码";
    stockSearchTextField.keyboardType = UIKeyboardTypeNumberPad;
    stockSearchTextField.delegate = self;
    [stockSearchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    
    stockList = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    [self.tableView setDataSource:self];
    [self.tableView reloadData];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [stockSearchTextField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [stockSearchTextField becomeFirstResponder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 6*minSpace;
    }
    
    if(indexPath.section == 1){
        return 8*minSpace;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString* cellIdentifier = @"searchcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        cell.accessoryView = stockSearchTextField;
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    if(indexPath.section == 1){
        static NSString* cellIdentifier = @"stockcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
    return nil;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"添加到自选" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            ;
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"add stock to coredata");
            
        }];
        
        
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)textFieldDidChange:(UITextField*)textField
{
    if(textField.text.length == 6){
        NSLog(@"search stock code: %@", textField.text);
        NSString* stockCode = textField.text;
        
        
        //发送搜索消息
        NSDictionary* message = [[NSDictionary alloc]
                                 initWithObjects:@[stockCode]
                                 forKeys:@[@"stock_code"]];
        
        [NetworkAPI callApiWithParam:message childpath:@"/stock/getStock" successed:^(NSDictionary *response) {
            
            NSInteger code = [[response objectForKey:@"code"] integerValue];
            
            if(code == SUCCESS){
                
                [self loadStockInfo:[response objectForKey:@"data"]];
                
            }else if(code == STOCK_NOT_EXIST){
                [stockList removeAllObjects];
                [self.tableView reloadData];
                
            }else{
                alertMsg(@"未知错误");
            }
            
            
        } failed:^(NSError *error) {
            alertMsg(@"网络问题");
        }];

        
    }
}


- (void)loadStockInfo:(NSDictionary*)data
{
    StockInfoModel* stockInfo = [StockInfoModel yy_modelWithDictionary:data];
    [stockList removeAllObjects];
    [stockList addObject:stockInfo];
    [self.tableView reloadData];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        return @"搜索结果";
    }
    return @"";
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if(section == 1){
        return [stockList count];
    }
    
    return 0;
}

@end
