//
//  contactDataManager.m
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "contactDataManager.h"
#import "UtilFun.h"
#import "unit.h"
#import "NetWorkManager.h"
#import "person.h"
#import "department.h"
#import "Macro.h"

@implementation contactDataManager


+(void)DownloadDepartmentTreeSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        [self getSubDeptOfUnit:[department rootUnit] Success:^(id responseObject)
         {

                 success(nil);
                 return;

         }
                       failure:^(NSError *error)
         {

                 success(nil);

         }];
        
    });
}


+(void)WaitForDataB4ExpandUnit:(unit*)unt Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    if (unt == nil)
    {
        success(nil);
    }
    
    
    int retrieveCount = 2;//需要获取子部门数据和本部门直属员工数据
    //所有部门数据一次性获取，无需重复
    __block int retirevedCount = 0;
    
    static dispatch_once_t pred = 0;
    if (pred < 0) {
        retrieveCount = 1;
    }
    dispatch_once(&pred, ^{
        [self getSubDeptOfUnit:unt Success:^(id responseObject)
         {
             retirevedCount++;
             if (retirevedCount >= retrieveCount)
             {
                 success(nil);
                 return;
             }
         }
                       failure:^(NSError *error)
         {
             retirevedCount++;
             if (retirevedCount >= retrieveCount)
             {
                 success(nil);
                 return;
             }
         }];
        
    });
    
    
//    if (unt.isDept &&[unt.subDept count] > 0 && [unt.subPerson count] > 0)
//    {
//        retirevedCount++;
//        if (retirevedCount >= retrieveCount)
//        {
//            success(nil);
//            return;
//        }
//    }
//    else
    {
        
        [self getSubPersonsOfUnit:unt Success:^(id responseObject)
         {
             retirevedCount++;
             if (retirevedCount >= retrieveCount)
             {
                 success(nil);
                 return;
             }
         }
                          failure:^(NSError *error)
         {
             retirevedCount++;
             if (retirevedCount >= retrieveCount)
             {
                 success(nil);
                 return;
             }
         }];
    }
    
}

+(void)getSubDeptOfUnit:(unit*)unt Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
{
    if (![unt hasSubUnits])
    {
        success(nil);
        return;
    }
    //为了提高速度，已经取过的数据不再重新获取
    //如果需要重新获取必须重启客户端
    if ([unt.subDept count] > 0)
    {
        success(nil);
        return;
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
             NSArray*arr = [self getDeptArr:resultDic superUnit:unt];;

             [unt setSubUnits:arr];
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
    if (![unt hasSubUnits] || unt == [department rootUnit])
    {
        success(nil);
        return;
    }
    
    //为了提高速度，已经取过的数据不再重新获取
    //如果需要重新获取必须重启客户端
//    if ([unt.subPerson count] > 0)
//    {
//        success(nil);
//        return;
//    }
    
     NSString*no = unt.isDept?(((department*)unt).dept_current_no):(((person*)unt).job_no);
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"dept_current_no":no,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_GET_SUB_UNIT parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             NSArray*arr = [self getPersonArr:resultDic];;
             NSMutableArray*tmpArr = [[NSMutableArray alloc] init];
             for (person*objUnt in arr)
             {
                 BOOL bExist = NO;
                 for (person*psn in unt.subPerson)
                 {
                     if ([psn.job_no isEqualToString:objUnt.job_no])
                     {
                         [psn copyInfo:objUnt];
                         bExist = YES;
                         break;
                     }
                 }
                 
                 if (!bExist)
                 {
                     objUnt.superUnit = unt;
                     objUnt.level = unt.level+1;
                     objUnt.department_no = ((department*)unt).dept_current_no;
                     [tmpArr addObject:objUnt];
                 }
             }
             
             
             
             
             [unt.subPerson addObjectsFromArray:tmpArr];
             success(nil);
             return;
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
         return;
     }];
}

+(NSArray*)getDeptArr:(NSDictionary*)dic superUnit:(unit*)superUnit
{
    NSArray*annArr = [dic objectForKey:@"ContractDeptSubDeptNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*subDic in annArr)
    {
        department* obj = [[department alloc] init];
        [obj initWithDictionary:subDic];
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


+(void)searchUnitByKeyWord:(NSString *)kw Success:(void (^)(NSArray *personArr,NSArray*dptArr))success failure:(void (^)(NSError *error))failure
{
    void (^searchBlock) (NSString*kw)  = ^(NSString*a){
        NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] init];
        [mutDic setValue:[person me].job_no forKey:@"job_no"];
        [mutDic setValue:[person me].password forKey:@"acc_password"];
        [mutDic setValue:[UtilFun getUDID] forKey:@"DeviceID"];
        [mutDic setValue:DEVICE_IOS forKey:@"DeviceType"];
        [mutDic setValue:kw forKey:@"SearchName"];
        
        [NetWorkManager PostWithApiName:API_SEARCH_BY_KEWORD parameters:mutDic success:
         ^(id responseObject)
         {
             NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             if ([bizManager checkReturnStatus:resultDic Success:nil failure:failure ShouldReturnWhenSuccess:NO])
             {
                 success([self getSearchResultPersonArr:resultDic],[self getSearchResultDeptArr:resultDic]);
             }
             
             
         }
                                failure:^(NSError *error)
         {
             failure(error);
         }];
    };
    
    
    
    if ([[[department rootUnit] subDept] count] == 0)
    {
        [self DownloadDepartmentTreeSuccess:^(id responseObject) {
            
            searchBlock(kw);
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    else
    {
        searchBlock(kw);
    }

}

+(NSArray*)getSearchResultPersonArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"AddressListNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    if ([annArr respondsToSelector:@selector(count)])
    {
        if ([annArr count] > 0)
        {
            for (NSDictionary*dic in annArr)
            {
                person* psn = [[person alloc] init];
                [psn initWithDictionary:dic];

                [arr  addObject:psn];
                
            }
        }
        
    }
    
    if ([arr count] == 0)
    {
        return nil;
    }
    
    return arr;
}

+(NSArray*)getSearchResultDeptArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"DeptListNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    if ([annArr respondsToSelector:@selector(count)])
    {
        if ([annArr count] > 0)
        {
            for (NSDictionary*dic in annArr)
            {
                department* dpt = [[department alloc] init];
                [dpt initWithDictionary:dic];
                department*dptFound = [(department*)[department rootUnit] findSubDepartmentByNo:dpt.dept_current_no];
                
                
                
                
                [arr  addObject:dptFound];
                
            }
        }
        
    }
    
    if ([arr count] == 0)
    {
        return nil;
    }
    
    return arr;
}


+(void)getPsnByJobNo:(NSString*)jobNo Success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary*mutDic = [[NSMutableDictionary alloc] init];
    [mutDic setValue:[person me].job_no forKey:@"job_no"];
    [mutDic setValue:[person me].password forKey:@"acc_password"];
    [mutDic setValue:[UtilFun getUDID] forKey:@"DeviceID"];
    [mutDic setValue:DEVICE_IOS forKey:@"DeviceType"];
    [mutDic setValue:jobNo forKey:@"get_job"];
    
    [NetWorkManager PostWithApiName:API_GET_PSN_DETAILS parameters:mutDic success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:nil failure:failure ShouldReturnWhenSuccess:NO])
         {
             person*psn = [[person alloc] init];
             [psn initWithDictionary:[[resultDic  objectForKey:@"UserInfoNode"] objectAtIndex:0]];
             success(psn);
         }
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}


@end
