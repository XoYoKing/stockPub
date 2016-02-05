//
//  getFollowUserAction.m
//  stockFront
//
//  Created by wang jam on 2/1/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "getFollowUserAction.h"
#import "NetworkAPI.h"
#import "returnCode.h"
#import "macro.h"
#import "UserInfoModel.h"
#import <YYModel.h>


@implementation getFollowUserAction
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
                             forKeys:@[@"user_id", @"follow_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getfollowUser" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [list removeAllObjects];
            
            NSArray* userlist = (NSArray*)[response objectForKey:@"data"];
            
            if(userlist!=nil){
                for (NSDictionary* element in userlist) {
                    UserInfoModel* temp = [UserInfoModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                
                [list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    UserInfoModel* element1 = (UserInfoModel*)obj1;
                    UserInfoModel* element2 = (UserInfoModel*)obj2;
                    
                    return element1.follow_timestamp<element2.follow_timestamp;
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
    UserInfoModel* userInfo = [list lastObject];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[user_id,
                                               [[NSNumber alloc] initWithDouble:userInfo.follow_timestamp]]
                             forKeys:@[@"user_id", @"follow_timestamp"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getfollowUser" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSArray* userlist = (NSArray*)[response objectForKey:@"data"];
            
            if(userlist!=nil){
                for (NSDictionary* element in userlist) {
                    UserInfoModel* temp = [UserInfoModel yy_modelWithDictionary:element];
                    [list addObject:temp];
                }
                
                [list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    UserInfoModel* element1 = (UserInfoModel*)obj1;
                    UserInfoModel* element2 = (UserInfoModel*)obj2;
                    
                    return element1.follow_timestamp<element2.follow_timestamp;
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
