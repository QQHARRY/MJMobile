//
//  SignDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "SignDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "bizManager.h"
#import "UtilFun.h"
#import "AFNetworking.h"

@implementation SignDataPuller

+(void)pushNewSignWithParam:(NSDictionary *)param Success:(void (^)(NSString *signNo))success failure:(void (^)(NSError *error))failure
{
    [NetWorkManager PostWithApiName:API_CREATE_SIGN parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSString *src = [resultDic objectForKey:@"meeting_sign_apply_no"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullClientWithFilter:(ClientFilter *)filter Success:(void (^)(NSArray *clientList))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    [param setValue:filter.FromID forKey:@"FromID"];
    [param setValue:filter.ToID forKey:@"ToID"];
    [param setValue:filter.Count forKey:@"Count"];
    if (filter.dept_current_no.length > 0)
    {
        [param setValue:filter.dept_current_no forKey:@"dept_current_no"];
    }
    if (filter.client_owner_no.length > 0)
    {
        [param setValue:filter.client_owner_no forKey:@"client_owner_no"];
    }
    if (filter.start_date.length > 0)
    {
        [param setValue:filter.start_date forKey:@"start_date"];
    }
    if (filter.end_date.length > 0)
    {
        [param setValue:filter.end_date forKey:@"end_date"];
    }
    
    [NetWorkManager PostWithApiName:API_CLIENT_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"ClientNode"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullSignConditionListDataSuccess:(void (^)(NSDictionary *conditionSrc))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    
    [NetWorkManager PostWithApiName:API_SIGN_CONDITION parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success(resultDic);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullMySignListWithFrom:(NSString *)fid To:(NSString *)tid Success:(void (^)(NSArray *ContractList))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    [param setValue:fid forKey:@"FromID"];
    [param setValue:tid forKey:@"ToID"];
    [param setValue:@"10" forKey:@"Count"];
    
    [NetWorkManager PostWithApiName:API_MY_SIGN_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"AppointmentSigningNode"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
