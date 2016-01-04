//
//  NetworkAPI.h
//  stockFront
//
//  Created by wang jam on 1/4/16.
//  Copyright © 2016 jam wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkAPI : NSObject

+ (void)callApiWithParam:(NSDictionary*)param successed:(void(^)(NSDictionary *response))successedBlock failed:(void(^)(NSError* error))failedBlock;

@end
