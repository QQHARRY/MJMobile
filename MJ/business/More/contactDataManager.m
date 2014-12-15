//
//  contactDataManager.m
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "contactDataManager.h"
#import "unit.h"
#import "NetWorkManager.h"
#import "person.h"
#import "department.h"
#import "Macro.h"

@implementation contactDataManager

+(unit*)getContactList
{
    return nil;
}

+(void)getSubDeptOfUnit:(unit*)unt Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
{
    if (![unt hasSubUnits])
    {
        success(nil);
    }
    //为了提高速度，已经取过的数据不再重新获取
    //如果需要重新获取必须重启客户端
    if ([unt.subDept count] > 0)
    {
        success(nil);
    }
    
    NSString*no = unt.isDept?(((department*)unt).dept_current_no):(((person*)unt).job_no);
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"dept_current_no":no,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_GET_SUB_DEPT parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray*arr = [self getDeptArr:resultDic];;
             for (unit*objUnt in arr)
             {
                 objUnt.superUnit = unt;
                 objUnt.level = unt.level+1;
             }
             [unt.subDept addObjectsFromArray:arr];
             success(nil);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(void)getSubPersonsOfUnit:(unit*)unt Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
{
    if (![unt hasSubUnits])
    {
        success(nil);
    }
    
    //为了提高速度，已经取过的数据不再重新获取
    //如果需要重新获取必须重启客户端
    if ([unt.subPerson count] > 0)
    {
        success(nil);
    }
    
     NSString*no = unt.isDept?(((department*)unt).dept_current_no):(((person*)unt).job_no);
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"dept_current_no":no,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_GET_SUB_PERSON parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray*arr = [self getPersonArr:resultDic];;
             for (unit*objUnt in arr)
             {
                 objUnt.superUnit = unt;
                 objUnt.level = unt.level+1;
             }
             [unt.subDept addObjectsFromArray:arr];
             success(nil);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(NSArray*)getDeptArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"ContractDeptSubDeptNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        unit* obj = [[department alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}

+(NSArray*)getPersonArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"ContractDeptUsrNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        unit* obj = [[person alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}


@end
