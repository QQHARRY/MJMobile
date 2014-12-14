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


//#define TEST_UNREAD


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
         BOOL checkRet = [self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO];
         
         if (checkRet)
         {

             
             NSString* strCount  = [resultDic objectForKey:@"Count"];
             int count  =[strCount intValue];
#ifdef TEST_UNREAD
             count = 123;
#endif
             
             unReadAlertCnt = count;
             success(nil);
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
         BOOL checkRet = [self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO];
         
         if (checkRet)
         {


             NSString* strCount  = [resultDic objectForKey:@"Count"];
             int count  =[strCount intValue];
#ifdef TEST_UNREAD
             count = 456;
#endif
             
                 unReadMessageCount = count;
                 success(nil);
         }
 
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
