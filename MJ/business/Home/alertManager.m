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

+(void)getAlertListReaded:(BOOL)readed From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString* strID = [person me].job_no;
    NSString* strPwd = [person me].password;
    
    
    NSString*readFlag = readed?@"1":@"2";
    
    
    
    NSDictionary *parameters = @{@"job_no":strID,
                                 @"acc_password":strPwd,
                                 @"task_reminder_flg":readFlag,
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                };
    
    
    [NetWorkManager PostWithApiName:API_ALERT_LIST parameters:parameters success:
     ^(id responseObject)
     {
         
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString*Status = [resultDic objectForKey:@"Status"];
         
         
         if (Status == nil || [Status  length] <= 0)
         {
             NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:SERVER_NONCOMPLIANCE_INFO}];
             failure(error);
         }
         else
         {
             NSInteger iStatus = [Status intValue];
             if (iStatus == 0)
             {
                 NSString* strCount  = [resultDic objectForKey:@"AlertNode"];
                 int count  =[strCount intValue];
                 if (count < 0)
                 {
                     NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:SERVER_NONCOMPLIANCE_INFO}];
                     failure(error);
                 }
                 else
                 {
                     
                     success(nil);
                 }
             }
             else
             {
                 NSString*strError = [resultDic objectForKey:@"ErrorInfo"];
                 NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:strError}];
                 failure(error);
             }
             
         }
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}
@end
