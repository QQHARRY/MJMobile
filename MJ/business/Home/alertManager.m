//
//  alertManager.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "alertManager.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "alert.h"

@implementation alertManager

+(void)getListReaded:(BOOL)readed From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{

  
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"task_reminder_flg":(readed?@"2":@"1"),
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                };
    
    
    [NetWorkManager PostWithApiName:API_ALERT_LIST parameters:parameters success:
     ^(id responseObject)
     {
          NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             success([self getArr:resultDic]);
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

+(NSArray*)getArr:(NSDictionary*)dic
{
    NSArray*annArr = [dic objectForKey:@"AlertNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        alert* obj = [[alert alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}
@end
