//
//  ContactDataProvider.m
//  MJ
//
//  Created by harry on 15/4/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactDataProvider.h"
#import "person.h"
#import "department.h"
#import "Macro.h"
#import "UtilFun.h"
#import "NetWorkManager.h"
#import "contactDataManager.h"


@implementation ContactDataProvider


#if 0
+(void)searchUnitByKeyWord:(NSString *)kw Success:(void (^)(NSArray *personArr,NSArray*dptArr))success failure:(void (^)(NSError *error))failure
{
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
             success([self getPersonArr:resultDic],[self getDeptArr:resultDic]);
         }
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(NSArray*)getPersonArr:(NSDictionary*)dic
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

+(NSArray*)getDeptArr:(NSDictionary*)dic
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
                [arr  addObject:dpt];
                
            }
        }
        
    }
    
    if ([arr count] == 0)
    {
        return nil;
    }
    
    return arr;
}


#endif

@end
