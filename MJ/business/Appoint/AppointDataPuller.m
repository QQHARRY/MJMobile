//
//  AppointDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AppointDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "HouseDetail.h"
#import "bizManager.h"
#import "UtilFun.h"
#import "AFNetworking.h"

@implementation AppointDataPuller

+(void)pullDataWithFilter:(NSString *)sid Success:(void (^)(NSArray *AppointList))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    [param setValue:sid forKey:@"appoint_obj_no"];
    [param setValue:@"0" forKey:@"FromID"];
    [param setValue:@"0" forKey:@"ToID"];
    [param setValue:@"1000" forKey:@"Count"];

    [NetWorkManager PostWithApiName:API_APPOINT_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"AppointNode"];
             success(src);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
