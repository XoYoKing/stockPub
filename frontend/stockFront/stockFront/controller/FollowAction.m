//
//  FollowAction.m
//  stockFront
//
//  Created by wang jam on 1/5/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "FollowAction.h"
#import "macro.h"
#import "NetworkAPI.h"
#import "StockLookInfoModel.h"
#import "returnCode.h"
#import <YYModel.h>


@implementation FollowAction
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

- (void)pullDownAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview
{
    
    
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[user_id,
                                               [[NSNumber alloc] initWithDouble:[[NSDate date] timeIntervalSince1970]*1000]]
                             forKeys:@[@"user_id", @"look_update_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/getFollowLookInfo" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [list removeAllObjects];
            
            NSArray* stocklist = (NSArray*)[response objectForKey:@"data"];
            
            if(stocklist!=nil){
                for (NSDictionary* element in stocklist) {
                    StockLookInfoModel* temp = [StockLookInfoModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                
                [list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    StockLookInfoModel* element1 = (StockLookInfoModel*)obj1;
                    StockLookInfoModel* element2 = (StockLookInfoModel*)obj2;
                    
                    return element1.look_update_timestamp<element2.look_update_timestamp;
                }];
                
                [tableview reloadData];
            }
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
        completedBlock();
    }];

}

- (void)pullUpAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview
{
    
    StockLookInfoModel* stockLookInfo = [list lastObject];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[user_id,
                                               [[NSNumber alloc] initWithDouble:stockLookInfo.look_update_timestamp]]
                             forKeys:@[@"user_id", @"look_update_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/stock/getFollowLookInfo" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSArray* stocklist = (NSArray*)[response objectForKey:@"data"];
            
            if(stocklist!=nil){
                for (NSDictionary* element in stocklist) {
                    StockLookInfoModel* temp = [StockLookInfoModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                
                [list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    StockLookInfoModel* element1 = (StockLookInfoModel*)obj1;
                    StockLookInfoModel* element2 = (StockLookInfoModel*)obj2;
                    
                    return element1.look_update_timestamp<element2.look_update_timestamp;
                }];
                
                [tableview reloadData];
            }
            
            
        }else{
            [Tools AlertBigMsg:@"未知错误"];
        }
        
        
    } failed:^(NSError *error) {
        [Tools AlertBigMsg:@"网络问题"];
        completedBlock();
    }];
}


@end
