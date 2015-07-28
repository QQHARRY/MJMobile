//
//  NetWorkManager.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNMJInstance.h"


@implementation NetWorkManager



+(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    [[AFNMJInstance instance]  PostWithApiName:apiName parameters:parameters success:success failure:failure];
}


+(void)PostImage:(UIImage*)image WithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    [[AFNMJInstance instance]  PostImage:image WithApiName:apiName parameters:parameters success:success failure:failure];
}

@end
