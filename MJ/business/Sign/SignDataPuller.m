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

+(void)pullCustomListWithParam:(NSDictionary *)param Success:(void (^)(NSArray *customList))success failure:(void (^)(NSError *error))failure
{
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

//+(void)pullCustomerListDataSuccess:(void (^)(NSArray *areaList))success failure:(void (^)(NSError *error))failure
//{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:[person me].job_no forKey:@"job_no"];
//    [param setValue:[person me].password forKey:@"acc_password"];
//    
//    [NetWorkManager PostWithApiName:API_AREA_LIST parameters:param success:^(id responseObject)
//     {
//         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
//         {
//             NSArray *src = [resultDic objectForKey:@"AreaNode "];
//             NSMutableArray *dst = [NSMutableArray array];
//             // search area
//             for (NSDictionary *dict in src)
//             {
//                 if ([[dict valueForKey:@"areas_parent_no"] isEqualToString:@"AREAS_NO000008"])
//                 {
//                     NSDictionary *areaDict = @{@"no" : [dict valueForKey:@"areas_current_no"],
//                                                @"dict" : dict,
//                                                @"sections" : [NSMutableArray array]};
//                     [dst addObject:areaDict];
//                 }
//             }
//             // search section
//             for (NSDictionary *dict in src)
//             {
//                 for (NSDictionary *areaDict in dst)
//                 {
//                     if ([[dict valueForKey:@"areas_parent_no"] isEqualToString:[areaDict objectForKey:@"no"]])
//                     {
//                         [[areaDict objectForKey:@"sections"] addObject:dict];
//                         break;
//                     }
//                 }
//             }
//             success(dst);
//         }
//     }
//                            failure:^(NSError *error)
//     {
//         failure(error);
//     }];
//}

@end
