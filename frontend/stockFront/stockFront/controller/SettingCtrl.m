//
//  SettingCtrl.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "SettingCtrl.h"
#import "StockSearchTableViewCtrl.h"
#import "StockLookInfoModel.h"

#import "macro.h"
#import "returnCode.h"
#import "FaceCellViewTableViewCell.h"
#import "NetworkAPI.h"
#import "AppDelegate.h"
#import <YYModel.h>
#import <Masonry.h>
#import "StockLookTableViewCell.h"

@implementation SettingCtrl
{
    NSMutableArray* stockLookList;
    NSMutableArray* hisStockLookList;
    UserInfoModel* myInfo;
}


- (id)init:(UserInfoModel*)userInfo
{
    if(self = [super initWithStyle:UITableViewStylePlain]){
        myInfo = userInfo;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.tableView reloadData];
}

- (void)viewDidLoad
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setText:myInfo.user_name];
    [navTitle setFont:[UIFont fontWithName:fontName size:middleFont]];
    navTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(pullDownAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    
    stockLookList = [[NSMutableArray alloc] init];
    
    [self pullDownAction];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return 6*minSpace;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return [self getStockSectionView];
    }else{
        return NULL;
    }
}

- (UIView*)getStockSectionView
{
    //当前看多
    UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6*minSpace)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    //股票名称
    UILabel* stockNameLabel = [[UILabel alloc] init];
    stockNameLabel.font = [UIFont fontWithName:fontName size:minFont];
    stockNameLabel.textColor = [UIColor grayColor];
    stockNameLabel.text = @"股票名称";
    stockNameLabel.textAlignment = NSTextAlignmentCenter;
    
    //现价成本
    UILabel* priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont fontWithName:fontName size:minFont];
    priceLabel.textColor = [UIColor grayColor];
    priceLabel.text = @"现价/成本";
    priceLabel.textAlignment = NSTextAlignmentCenter;

    
    //浮动盈亏
    UILabel* yieldLabel = [[UILabel alloc] init];
    yieldLabel.font = [UIFont fontWithName:fontName size:minFont];
    yieldLabel.textColor = [UIColor grayColor];
    yieldLabel.text = @"浮动盈亏";
    yieldLabel.textAlignment = NSTextAlignmentCenter;

    
    [sectionView addSubview:stockNameLabel];
    [sectionView addSubview:priceLabel];
    [sectionView addSubview:yieldLabel];
    
    
    [stockNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionView.mas_left);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stockNameLabel.mas_right);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    [yieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLabel.mas_right);
        make.centerY.mas_equalTo(sectionView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, sectionView.frame.size.height));
    }];
    
    return sectionView;

}

- (void)pullDownAction
{
    
    //获取当前看多股票详情
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[myInfo.user_id]
                             forKeys:@[@"user_id"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/getLookInfoByUser" successed:^(NSDictionary *response) {
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [stockLookList removeAllObjects];
            
            NSArray* stockLookInfoArray = (NSArray*)[response objectForKey:@"data"];
            if(stockLookInfoArray!=nil){
                for (NSDictionary* element in stockLookInfoArray) {
                    StockLookInfoModel* temp = [StockLookInfoModel yy_modelWithDictionary:element];
                    [stockLookList addObject:temp];
                }
            }
            
        }else{
            alertMsg(@"未知错误");
        }
        
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        alertMsg(@"网络问题");
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
        [self.tableView reloadData];

    }];
    
    //获取用户基本信息
    
    
}

- (void)searchAction:(id)sender
{
    //[self.navigationController pushViewController:[[StockSearchTableViewCtrl alloc] init] animated:YES];

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString* cellIdentifier = @"facecell";
        FaceCellViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[FaceCellViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        [cell configureCell:myInfo];
        
        return cell;
    }
    
    
    if(indexPath.section == 1){
        static NSString* cellIdentifier = @"followcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"ta关注的人";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%ld", myInfo.user_follow_count];
        }
        
        if(indexPath.row == 1){
            cell.textLabel.text = @"关注ta的人";
            cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%ld", myInfo.user_fans_count];
        }
        cell.detailTextLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    if(indexPath.section == 2){
        
        //当前看多股票收益
        static NSString* cellIdentifier = @"stockLook";
        StockLookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[StockLookTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        [cell configureCell:[stockLookList objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    if(indexPath.section == 3){
        
        //历史记录
        static NSString* cellIdentifier = @"hisStockLook";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:fontName size:minMiddleFont];
        return cell;
    }
    
    return nil;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
        return @"当前看多";
    }
    
    if (section == 3){
        return @"历史记录";
    }
    
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [FaceCellViewTableViewCell cellHeight];
    }
    
    if(indexPath.section == 1){
        return 6*minSpace;
    }
    
    if(indexPath.section == 2||indexPath.section == 3){
        return 8*minSpace;
    }
    
    return 0;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return 2;
    }
    
    if(section == 2){
        return [stockLookList count];
    }
    
    if(section == 3){
        return [hisStockLookList count];
    }
    
    return 0;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


@end
