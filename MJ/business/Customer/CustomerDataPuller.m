//
//  CustomerDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "CustomerDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "CustomerDetail.h"
#import "bizManager.h"
#import "UtilFun.h"

@implementation CustomerDataPuller

+(void)pullDataWithFilter:(CustomerFilter *)filter Success:(void (^)(NSArray *CustomerDetailList))success failure:(void (^)(NSError *error))failure;
{
    assert(filter);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    if (filter.user_no && filter.user_no.length > 0)
    {
        [param setValue:filter.user_no forKey:@"user_no"];
    }
    
    if (filter.dept_no && filter.dept_no.length > 0)
    {
        [param setValue:filter.dept_no forKey:@"dept_no"];
    }
    if (filter.house_urban && filter.house_urban.length > 0)
    {
        [param setValue:filter.house_urban forKey:@"house_urban"];
    }
    if (filter.house_area && filter.house_area.length > 0)
    {
        [param setValue:filter.house_area forKey:@"house_area"];
    }
    if (filter.business_requirement_type && filter.business_requirement_type.length > 0)
    {
        [param setValue:filter.business_requirement_type forKey:@"business_requirement_type"];
    }
    if (filter.requirement_status && filter.requirement_status.length > 0)
    {
        [param setValue:filter.requirement_status forKey:@"requirement_status"];
    }
    if (filter.client_name && filter.client_name.length > 0)
    {
        [param setValue:filter.client_name forKey:@"client_name"];
    }
    if (filter.obj_mobile && filter.obj_mobile.length > 0)
    {
        [param setValue:filter.obj_mobile forKey:@"obj_mobile"];
    }
    if (filter.start_date && filter.start_date.length > 0)
    {
        [param setValue:filter.start_date forKey:@"start_date"];
    }
    if (filter.end_date && filter.end_date.length > 0)
    {
        [param setValue:filter.end_date forKey:@"end_date"];
    }
    if (filter.FromID && filter.FromID.length > 0)
    {
        [param setValue:filter.FromID forKey:@"FromID"];
    }
    if (filter.ToID && filter.ToID.length > 0)
    {
        [param setValue:filter.ToID forKey:@"ToID"];
    }
    if (filter.Count && filter.Count.length > 0)
    {
        [param setValue:filter.Count forKey:@"Count"];
    }
    
    [NetWorkManager PostWithApiName:API_CUSTOMER_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray *src = [resultDic objectForKey:@"CustomerNode"];
             NSMutableArray *dst = [NSMutableArray array];
             for (NSDictionary *d in src)
             {
                 CustomerDetail *o = [[CustomerDetail alloc] init];
                 [o initWithDictionary:d];
                 [dst addObject:o];
             }
             success(dst);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullCustomerParticulars:(CustomerDetail *)detail Success:(void(^)(CustomerParticulars *particulars))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"business_requirement_no":detail.business_requirement_no,
                                 };
    
    [NetWorkManager PostWithApiName:API_CUSTOM_PARTICULARS parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             CustomerParticulars *particulars = [[CustomerParticulars alloc] init];
             NSDictionary*dic =[[resultDic  objectForKey:@"CustomerDetailsNode"] objectAtIndex:0];
             [particulars initWithDictionary:[[resultDic  objectForKey:@"CustomerDetailsNode"] objectAtIndex:0]];
             success(particulars);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)pullCustomerSecret:(CustomerDetail *)detail Success:(void(^)(CustomerSecret *secret))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"business_requirement_no":detail.business_requirement_no,
                                 };
    
    [NetWorkManager PostWithApiName:API_CUSTOM_SECRET parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             CustomerSecret *secret = [[CustomerSecret alloc] init];
             [secret initWithDictionary:[[resultDic objectForKey:@"CustomerSecretNode"] objectAtIndex:0]];
             success(secret);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


+(void)pullAddCustomer:(NSDictionary *)dic Success:(void(^)(id obj))success failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic1 setValue:[person me].job_no forKey:@"job_no"];
    [dic1 setValue:[person me].password forKey:@"acc_password"];
    [dic1 setValue:[UtilFun getUDID] forKey:@"DeviceID"];
    [dic1 setValue:[person me].department_no forKey:@"dept_no"];

    
    [NetWorkManager PostWithApiName:API_ADD_CUSTOM parameters:dic1 success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             
             success(nil);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


/**
 *  编辑客户信息
 *
 *  @param dic     新的客户信息
 *  @param success 成功
 *  @param failure 失败
 */
+(void)pullEditCustomer:(NSDictionary *)dic Success:(void(^)(id obj))success failure:(void (^)(NSError *error))failure
{
    
    NSMutableDictionary* dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic1 setValue:[person me].job_no forKey:@"job_no"];
    [dic1 setValue:[person me].password forKey:@"acc_password"];
    [dic1 setValue:[UtilFun getUDID] forKey:@"DeviceID"];
    
    
    [NetWorkManager PostWithApiName:API_EDIT_CUSTOM parameters:dic1 success:
     ^(id responseObject)
     {
         NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             
             success(nil);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
