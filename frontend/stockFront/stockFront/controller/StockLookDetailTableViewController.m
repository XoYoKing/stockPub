//
//  StockLookDetailTableViewController.m
//  stockFront
//
//  Created by wang jam on 1/24/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockLookDetailTableViewController.h"
#import "StockLookDetailTableViewCell.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "NetworkAPI.h"
#import "macro.h"
#import "returnCode.h"
#import "LocDatabase.h"

@interface StockLookDetailTableViewController ()
{
    LocDatabase* locDatabase;
}
@end

@implementation StockLookDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationController.navigationController.navigationBar.translucent = NO;
    
    
    UserInfoModel* phoneUser = [AppDelegate getMyUserInfo];
    if([phoneUser.user_id isEqualToString:_stockLookInfoModel.user_id]){
        if (_stockLookInfoModel.look_status == 1) {
            //有效
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消看多" style:UIBarButtonItemStylePlain target:self action:@selector(cancelLook:)];
        }
    }
    
    
    locDatabase = [AppDelegate getLocDatabase];
    
}

- (void)cancelLook:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[_stockLookInfoModel.user_id,
                                               _stockLookInfoModel.user_name, _stockLookInfoModel.stock_code, _stockLookInfoModel.stock_name]
                             forKeys:@[@"user_id", @"user_name", @"stock_code", @"stock_name"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/dellook" successed:^(NSDictionary *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            StockInfoModel* stockInfo = [[StockInfoModel alloc] init];
            stockInfo.stock_code = _stockLookInfoModel.stock_code;
            if(![locDatabase deleteLookStock:stockInfo]){
                alertMsg(@"操作失败");
            }else{
                //alertMsg(@"已删除");
                [_stocklist removeObject:_stockLookInfoModel];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            //[self.navigationController popoverPresentationController];
        }else{
            alertMsg(@"未知错误");
        }
        
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        alertMsg(@"网络问题");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    if(_stockLookInfoModel!=nil){
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StockLookDetailTableViewCell cellHeight];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"StockLookDetailTableViewCell";
    StockLookDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    // Configure the cell...
    if (cell==nil) {
        cell = [[StockLookDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSLog(@"new cell");
    }
    
    
    [cell configureCell:_stockLookInfoModel];
    
    return cell;

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
