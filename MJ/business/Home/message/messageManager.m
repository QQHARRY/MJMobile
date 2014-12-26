//
//  messageManager.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "messageManager.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "person.h"
#import "messageObj.h"
#import "UtilFun.h"

@implementation messageManager


+(void)getMsgByType:(MJMESSAGETYPE)msgType ListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"unread_flag":[NSNumber numberWithInt:msgType],

                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                 };
    
    
    [NetWorkManager PostWithApiName:GET_INNER_MESSAGE_LIST parameters:parameters success:
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

+(void)sendMessage:(messageObj*)msgObj Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure
{
    
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"msg_opt_user_list":msgObj.msg_opt_user_list,
                                 @"msg_bcc_user_list":msgObj.mg_bcc_user_list,
                                 @"msg_cc_user_list":msgObj.msg_cc_user_list,
                                 @"msg_title":msgObj.msg_title,
                                 @"msg_content":msgObj.msg_content,
                                 @"msg_save_date":date
                                 };
    
    
    [NetWorkManager PostWithApiName:SEND_INNER_MESSAGE parameters:parameters success:
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

+(void)setMessage:(messageObj*)msgObj ReadStatus:(MJMESSAGETYPE)status Success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceID":[UtilFun getUDID],
                                 @"msg_cno":msgObj.msg_cno,
                                 @"msg_index_cno":msgObj.msg_index_cno,
                                 @"msg_flag_no":msgObj.msg_flag_no,
                                 };
    
    
    [NetWorkManager PostWithApiName:SET_INNER_MESSAGE_READ_STATUS parameters:parameters success:
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
    NSArray*annArr = [dic objectForKey:@"MessageNode"];
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (NSDictionary*dic in annArr)
    {
        messageObj* obj = [[messageObj alloc] init];
        [obj initWithDictionary:dic];
        [arr  addObject:obj];
        
    }
    
    return arr;
}

@end
