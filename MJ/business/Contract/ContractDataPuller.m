//
//  ContractDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ContractDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "HouseDetail.h"
#import "bizManager.h"
#import "UtilFun.h"
#import "AFNetworking.h"

@implementation ContractDataPuller

+(void)pullDataWithFilter:(NSString *)sid Success:(void (^)(NSArray *ContractList))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"admin" forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    [param setValue:sid forKey:@"contract_target_object"];
    [param setValue:@"0" forKey:@"FromID"];
    [param setValue:@"0" forKey:@"ToID"];
    [param setValue:@"1000" forKey:@"Count"];

    [NetWorkManager PostWithApiName:API_CONTRACT_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"ContractNode"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pushNewContractWithParam:(NSDictionary *)param Success:(void (^)(NSString *ContractNo))success failure:(void (^)(NSError *error))failure
{
    [NetWorkManager PostWithApiName:API_CREATE_CONSTRACT parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSString *src = [resultDic objectForKey:@"task_Contract_no"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
