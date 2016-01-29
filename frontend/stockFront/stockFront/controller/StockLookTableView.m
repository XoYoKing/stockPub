//
//  StockLookTableView.m
//  stockFront
//
//  Created by wang jam on 1/29/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "StockLookTableView.h"
#import "StockLookInfoModel.h"
#import "StockLookDetailTableViewCell.h"

@implementation StockLookTableView
{
    NSMutableArray* list;
    ComTableViewCtrl* comtable;
}


- (void)initAction:(ComTableViewCtrl *)comTableViewCtrl
{
    comtable = comTableViewCtrl;
    [comTableViewCtrl.tableView setDelegate:self];
    [comTableViewCtrl.tableView setDataSource:self];
    
    list = [[NSMutableArray alloc] init];
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
    
    
    [cell configureCell:[list objectAtIndex:indexPath.row]];
    
    return cell;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [list count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [StockLookDetailTableViewCell cellHeight];
}

- (void)pullUpAction:(pullCompleted)completedBlock //上拉响应函数
{
    if(_pullAction!=nil&&[_pullAction respondsToSelector:@selector(pullUpAction:list:tableview:)]){
        [_pullAction pullUpAction:completedBlock list:list tableview:comtable.tableView];
    }else{
        completedBlock();
    }
}

- (void)pullDownAction:(pullCompleted)completedBlock //下拉响应函数
{
    if(_pullAction!=nil&&[_pullAction respondsToSelector:@selector(pullDownAction:list:tableview:)]){
        [_pullAction pullDownAction:completedBlock list:list tableview:comtable.tableView];
    }else{
        completedBlock();
    }
}

@end
