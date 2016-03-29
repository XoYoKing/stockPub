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
    
    //添加版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary* par = [[NSMutableDictionary alloc] initWithDictionary:param];
    [par setObject:app_build forKey:@"version"];
    
    
    [session POST:urlStr parameters:par success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        successedBlock((NSDictionary*)responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

+ (void)callApiWithParamForImage:(NSDictionary*)param imageDatas:(NSDictionary*)imageDatas childpath:(NSString*)childpath successed:(void(^)(NSDictionary *response))successedBlock failed:(void(^)(NSError* error))failedBlock
{
    AFHTTPSessionManager* session = [AFHTTPSessionManager manager];
    
    NSString* urlStr = [[NSString alloc] initWithFormat:@"%@%@", [ConfigAccess serverDomain], childpath];
    NSLog(@"%@", urlStr);
    
    //添加版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSMutableDictionary* par = [[NSMutableDictionary alloc] initWithDictionary:param];
    [par setObject:app_build forKey:@"version"];
    
    [session POST:urlStr parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString* key in imageDatas) {
            UIImage* image = [imageDatas objectForKey:key];
            NSData* imageData = UIImageJPEGRepresentation(image, 0.7);
            
            [formData appendPartWithFileData:imageData name:key
                                    fileName:key mimeType:@"image/jpeg"];
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successedBlock((NSDictionary*)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error);
    }];
}


@end
