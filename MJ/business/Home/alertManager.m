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

@implementation alertManager

+(void)getListReaded:(BOOL)readed From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{

  
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"task_reminder_flg":(readed?@"1":@"2"),
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                };
    
    
    [NetWorkManager PostWithApiName:API_ALERT_LIST parameters:parameters success:
     ^(id responseObject)
     {
         [self checkReturnStatus:responseObject Success:success failure:failure ShouldReturnWhenSuccess:YES];
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}
@end
