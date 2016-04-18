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
#import "HXEasyCustomShareView.h"
#import "WXApi.h"
#import "KLineCell.h"

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
//        if (_stockLookInfoModel.look_status == 1) {
//            //有效
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消看多" style:UIBarButtonItemStylePlain target:self action:@selector(cancelLook:)];
//        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more:)];
    }
    
    
    locDatabase = [AppDelegate getLocDatabase];
    
}

- (void)more:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    if(_stockLookInfoModel.look_status == 1){
        UIAlertAction* lookAction= [UIAlertAction actionWithTitle:@"取消看多" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self cancelLook:nil];
        }];
        [alertController addAction:lookAction];
    }
    
    UIAlertAction* shareAction= [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self addWeixinShareView];
        
    }];
    [alertController addAction:shareAction];
    
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title
{
    NSLog(@"%@", title);
    [shareView tappedCancel];
    
    //    UserInfoModel* user = [AppDelegate getMyUserInfo];
    
    if([title isEqualToString:@"朋友圈"]){
        NSString* title = [[NSString alloc] initWithFormat:@"%@%@(%@),%.2f(%.2f%%)",  @"看多了", _stockLookInfoModel.stock_name, _stockLookInfoModel.stock_code, _stockLookInfoModel.look_cur_price, _stockLookInfoModel.stock_yield];
        [self sendLinkContent:title scene:WXSceneTimeline];
    }
    
//    
    if([title isEqualToString:@"发送给朋友"]){
        NSString* title = [[NSString alloc] initWithFormat:@"%@%@(%@),%.2f(%.2f%%)",  @"看多了", _stockLookInfoModel.stock_name, _stockLookInfoModel.stock_code, _stockLookInfoModel.look_cur_price, _stockLookInfoModel.stock_yield];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        if(_stockLookInfoModel!=nil){
            return 1;
        }
        return 0;

    }
    
    if(section == 1){
        return 1;
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [StockLookDetailTableViewCell cellHeight];
    }
    
    if (indexPath.section == 1) {
        return [KLineCell cellHeight];
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
    
    if (indexPath.section == 1) {
        
        static NSString* cellIdentifier = @"klineCell";
        KLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[KLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        StockInfoModel* stockInfoModel = [[StockInfoModel alloc] init];
        stockInfoModel.is_market = 0;
        stockInfoModel.stock_code = _stockLookInfoModel.stock_code;
        [cell configureCell:stockInfoModel lookInfo:_stockLookInfoModel];
        return cell;
    }
    
    return nil;

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
