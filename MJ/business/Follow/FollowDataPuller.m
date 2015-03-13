//
//  FollowDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "FollowDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "HouseDetail.h"
#import "bizManager.h"
#import "UtilFun.h"
#import "AFNetworking.h"

@implementation FollowDataPuller

+(void)pullDataWithFilter:(NSString *)sid Success:(void (^)(NSArray *followList))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    [param setValue:sid forKey:@"task_obj_no"];
    [param setValue:@"0" forKey:@"FromID"];
    [param setValue:@"0" forKey:@"ToID"];
    [param setValue:@"1000" forKey:@"Count"];

    [NetWorkManager PostWithApiName:API_FOLLOW_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"FollowtNode"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pushNewFollowWithParam:(NSDictionary *)param Success:(void (^)(NSString *followNo))success failure:(void (^)(NSError *error))failure
{
    [NetWorkManager PostWithApiName:API_CREATE_FOLLOW parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSString *statusCode = [resultDic objectForKey:@"Status"];
             if ([statusCode isEqualToString:@"3"])
             {
                 success(@"E-1003");
                 return;
             }
             else
             {
                 NSString *src = [resultDic objectForKey:@"task_follow_no"];
                 success(src);
                 return;
             }
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
