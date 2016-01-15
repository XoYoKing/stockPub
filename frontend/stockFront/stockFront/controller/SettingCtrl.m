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

@implementation SettingCtrl
{
    NSMutableArray* stockLookList;
    NSMutableArray* hisStockLookList;
}

- (void)viewDidLoad
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    
    
    
    
}

- (void)searchAction:(id)sender
{
    //[self.navigationController pushViewController:[[StockSearchTableViewCtrl alloc] init] animated:YES];

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString* cellIdentifier = @"facecell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        // Configure the cell...
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    
    if(indexPath.section == 1){
        static NSString* cellIdentifier = @"followcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        return cell;
    }
    
    if(indexPath.section == 2){
        static NSString* cellIdentifier = @"followcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
        return cell;
    }
    
    
    if(indexPath.section == 3){
        static NSString* cellIdentifier = @"followcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"new cell");
        }
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
        return 8*minSpace;
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
