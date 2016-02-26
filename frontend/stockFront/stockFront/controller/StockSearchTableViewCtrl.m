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
#import "LocDatabase.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import "StockInfoDetailTableView.h"

@implementation StockSearchTableViewCtrl
{
    NSMutableArray* stockList;
    UITextField* stockSearchTextField;
    LocDatabase* locDatabase;
    BOOL searching;
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
    stockSearchTextField.placeholder = @"请输入股票名称或代码";
    stockSearchTextField.delegate = self;
    [stockSearchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    
    UserInfoModel* myInfo = [AppDelegate getMyUserInfo];
    locDatabase = [[LocDatabase alloc] init];
    if(![locDatabase connectToDatabase:myInfo.user_id]){
        alertMsg(@"本地数据问题");
        return;
    }

    
    
    
    stockList = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    
    searching = false;

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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [stockSearchTextField resignFirstResponder];
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
//        UILabel* priceLabel = [[UILabel alloc] init];
//        priceLabel.font = [UIFont fontWithName:fontName size:middleFont];
//        
//        if (stockInfo.fluctuate>0) {
//            priceLabel.textColor = myred;
//            priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(+%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
//        }
//        
//        if(stockInfo.fluctuate<0){
//            priceLabel.textColor = mygreen;
//            priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
//        }
//        
//        if(stockInfo.fluctuate == 0){
//            priceLabel.textColor = [UIColor blackColor];
//            priceLabel.text = [[NSString alloc] initWithFormat:@"%.2lf(%.2lf%%)", stockInfo.price, stockInfo.fluctuate];
//        }
//        
//        CGSize labelSize = [Tools getTextArrange:priceLabel.text maxRect:CGSizeMake(ScreenWidth, 8*minSpace) fontSize:middleFont];
//        
//        priceLabel.frame = CGRectMake(ScreenWidth - labelSize.width - 10, 0, labelSize.width+10, labelSize.height);
        
        
        
        
        
        
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:minFont];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    return nil;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"添加到自选" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            ;
//        }];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"add stock to coredata");
//            
//            StockInfoModel* stockModel = [stockList objectAtIndex:indexPath.row];
//            if(![locDatabase addStock:stockModel]){
//                alertMsg(@"添加自选失败");
//            }else{
//                alertMsg(@"已添加");
//            }
//        }];
//        
//        
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        
        
        StockInfoModel* stockModel = [stockList objectAtIndex:indexPath.row];
        StockInfoDetailTableView* detail = [[StockInfoDetailTableView alloc] init];
        detail.ismarket = false;
        detail.stockInfoModel = stockModel;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)textFieldDidChange:(UITextField*)textField
{
    if(textField.text.length >= 2&&searching == false){
        
        searching = true;
        
        NSLog(@"search stock str: %@", textField.text);
        
        
        //发送搜索消息
        NSDictionary* message = [[NSDictionary alloc]
                                 initWithObjects:@[textField.text]
                                 forKeys:@[@"stock_alpha_info"]];
        
        [NetworkAPI callApiWithParam:message childpath:@"/stock/getStock" successed:^(NSDictionary *response) {
            
            [stockList removeAllObjects];
            NSInteger code = [[response objectForKey:@"code"] integerValue];
            
            if(code == SUCCESS){
                
                NSArray* list = [response objectForKey:@"data"];
                for (NSDictionary* element in list) {
                    StockInfoModel* stockInfo = [StockInfoModel yy_modelWithDictionary:element];
                    [stockList addObject:stockInfo];
                }
                
                [self.tableView reloadData];
                
            }else if(code == STOCK_NOT_EXIST){
                alertMsg(@"未找到记录");
            }else{
                alertMsg(@"未知错误");
            }
            
            
            searching = false;
            
        } failed:^(NSError *error) {
            alertMsg(@"网络问题");
            searching = false;
        }];
    }
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
