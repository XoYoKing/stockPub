//
//  NetworkAPI.m
//  stockFront
//
//  Created by wang jam on 1/4/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import "NetworkAPI.h"
#import <AFHTTPSessionManager.h>
#import "ConfigAccess.h"

@implementation NetworkAPI

+ (void)callApiWithParam:(NSDictionary*)param childpath:(NSString*)childpath successed:(void(^)(NSDictionary *response))successedBlock failed:(void(^)(NSError* error))failedBlock
{
    
    AFHTTPSessionManager* session = [AFHTTPSessionManager manager];
    
    NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@", [ConfigAccess serverDomain], childpath];
    NSLog(@"%@", urlStr);
    
    [session POST:urlStr parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError* jsonError = nil;
        NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
        
        if(jsonError){
            failedBlock(jsonError);
        }else{
            successedBlock(responseDic);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
