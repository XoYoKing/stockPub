//
//  HisStockLookAction.m
//  stockFront
//
//  Created by wang jam on 1/29/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "HisStockLookAction.h"
#import "NetworkAPI.h"
#import <YYModel.h>
#import "StockLookInfoModel.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "macro.h"
#import "returnCode.h"

@implementation HisStockLookAction
{
    NSString* user_id;
}

- (id)init:(NSString*)userID
{
    if(self = [super init]){
        user_id = userID;
    }
    return self;
}

- (void)pullDownAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview;
{
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[user_id]
                             forKeys:@[@"user_id"]];

    [NetworkAPI callApiWithParam:message childpath:@"/stock/getHisLookInfoByUser" successed:^(NSDictionary *response) {
        completedBlock();
        [list removeAllObjects];
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSArray* stocklist = (NSArray*)[response objectForKey:@"data"];
            
            if(stocklist!=nil){
                for (NSDictionary* element in stocklist) {
                    StockLookInfoModel* temp = [StockLookInfoModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                [tableview reloadData];
            }
        }
        
    } failed:^(NSError *error) {
        completedBlock();
        [Tools AlertBigMsg:@"未知错误"];
    }];
}

//- (void)pullUpAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview;
//{
//    completedBlock();
//}

@end
