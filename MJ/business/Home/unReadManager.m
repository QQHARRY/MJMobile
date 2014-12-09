//
//  unReadManager.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "unReadManager.h"
#import "person.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "UtilFun.h"

static int unReadMessageCount = 0;
static int unReadAlertCnt = 0;


@implementation unReadManager

+(void)setUnReadMessageCount:(int)count
{
    unReadMessageCount = count;
}
+(void)setUnReadAlertCnt:(int)count
{
    unReadAlertCnt = count;
}
+(int)unReadAlertCnt
{
    return unReadAlertCnt;
}
+(int)unReadMessageCount
{
    return unReadMessageCount;
}

+(void)getUnReadAlertCntSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
{
    NSString* strID = [person me].job_no;
    NSString* strPwd = [person me].password;
    
    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd};
    
    
    [NetWorkManager PostWithApiName:API_ALERT_COUNT parameters:parameters success:
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
                 NSString* strCount  = [resultDic objectForKey:@"Count"];
                 int count  =[strCount intValue];
                 if (count < 0)
                 {
                     NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:SERVER_NONCOMPLIANCE_INFO}];
                     failure(error);
                 }
                 else
                 {
                     unReadAlertCnt = count;
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


+(void)getUnReadMessageCntSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
{
    NSString* strID = [person me].job_no;
    NSString* strPwd = [person me].password;
    
    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd};
    
    
    [NetWorkManager PostWithApiName:API_UNREAD_MSG_COUNT parameters:parameters success:
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
                 NSString* strCount  = [resultDic objectForKey:@"Count"];
                 int count  =[strCount intValue];
                 if (count < 0)
                 {
                     NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:SERVER_NONCOMPLIANCE_INFO}];
                     failure(error);
                 }
                 else
                 {
                     unReadMessageCount = count;
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
