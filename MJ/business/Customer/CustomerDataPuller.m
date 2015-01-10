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



@end
