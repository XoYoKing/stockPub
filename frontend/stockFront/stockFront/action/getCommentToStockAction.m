//
//  getCommentToStockAction.m
//  stockFront
//
//  Created by wang jam on 3/16/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "getCommentToStockAction.h"
#import "NetworkAPI.h"
#import "CommentModel.h"
#import "macro.h"
#import "returnCode.h"

@implementation getCommentToStockAction
{
    NSString* talk_stock_code;
}

- (id)initWithStockCode:(NSString*)stock_code{
    if(self = [super init]){
        talk_stock_code = stock_code;
    }
    return self;
}

- (void)pullUpAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview
{
    CommentModel* lastComment = [list lastObject];
    
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[talk_stock_code,
                                               [[NSNumber alloc] initWithInteger:lastComment.comment_timestamp]]
                             forKeys:@[@"talk_stock_code", @"talk_timestamp_ms"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getCommentToStock" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            NSArray* commentlist = (NSArray*)[response objectForKey:@"data"];
            
            if(commentlist!=nil){
                for (NSDictionary* element in commentlist) {
                    CommentModel* temp = [[CommentModel alloc] init];
                    temp.look_id = [element objectForKey:@"talk_id"];
                    temp.comment_user_id = [element objectForKey:@"talk_user_id"];
                    temp.comment_timestamp = [[element objectForKey:@"talk_timestamp_ms"] integerValue];
                    temp.comment_content = [element objectForKey:@"talk_content"];
                    temp.comment_user_name = [element objectForKey:@"user_name"];
                    temp.comment_user_facethumbnail = [element objectForKey:@"user_facethumbnail"];
                    if(![[element objectForKey:@"talk_to_user_id"] isEqual:[NSNull null]]){
                        temp.comment_to_user_id = [element objectForKey:@"talk_to_user_id"];
                        temp.comment_to_user_name = [element objectForKey:@"talk_to_user_name"];
                    }
                    
                    [list addObject:temp];
                }
                
                [list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    CommentModel* element1 = (CommentModel*)obj1;
                    CommentModel* element2 = (CommentModel*)obj2;
                    
                    return element1.comment_timestamp<element2.comment_timestamp;
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

- (void)pullDownAction:(pullCompleted)completedBlock list:(NSMutableArray *)list tableview:(UITableView *)tableview
{
    NSDictionary* message = [[NSDictionary alloc]
                             initWithObjects:@[talk_stock_code,
                                               [[NSNumber alloc] initWithInteger:[[NSDate date] timeIntervalSince1970]*1000]]
                             forKeys:@[@"talk_stock_code", @"talk_timestamp_ms"]];
    
    [NetworkAPI callApiWithParam:message childpath:@"/user/getCommentToStock" successed:^(NSDictionary *response) {
        
        completedBlock();
        
        NSInteger code = [[response objectForKey:@"code"] integerValue];
        
        if(code == SUCCESS){
            
            [list removeAllObjects];
            
            NSArray* commentlist = (NSArray*)[response objectForKey:@"data"];
            
            if(commentlist!=nil){
                for (NSDictionary* element in commentlist) {
                    CommentModel* temp = [[CommentModel alloc] init];
                    temp.look_id = [element objectForKey:@"talk_id"];
                    temp.comment_user_id = [element objectForKey:@"talk_user_id"];
                    temp.comment_timestamp = [[element objectForKey:@"talk_timestamp_ms"] integerValue];
                    temp.comment_content = [element objectForKey:@"talk_content"];
                    temp.comment_user_name = [element objectForKey:@"user_name"];
                    temp.comment_user_facethumbnail = [element objectForKey:@"user_facethumbnail"];
                    if(![[element objectForKey:@"talk_to_user_id"] isEqual:[NSNull null]]){
                        temp.comment_to_user_id = [element objectForKey:@"talk_to_user_id"];
                        temp.comment_to_user_name = [element objectForKey:@"talk_to_user_name"];
                    }
                    
                    [list addObject:temp];
                }
                
                [list sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    CommentModel* element1 = (CommentModel*)obj1;
                    CommentModel* element2 = (CommentModel*)obj2;
                    
                    return element1.comment_timestamp<element2.comment_timestamp;
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
