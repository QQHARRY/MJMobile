//
//  HouseDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseDataPuller.h"
#import "Macro.h"

@implementation HouseDataPuller

+(void)pullDataWithFilter:(HouseFilter *)filter Success:(void (^)(NSArray *houseDetailList))success failure:(void (^)(NSError *error))failure;
{
//    NSDictionary *parameters = @{@"job_no":[person me].job_no,
//                                 @"acc_password":[person me].password,
//                                 @"task_reminder_flg":(readed?@"2":@"1"),
//                                 @"FromID":from,
//                                 @"ToID":to,
//                                 @"Count":[NSNumber numberWithInt:count]
//                                 };
    
    
//    [NetWorkManager PostWithApiName:API_ALERT_LIST parameters:parameters success:
//     ^(id responseObject)
//     {
//         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         if ([self checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
//         {
//             success([self getArr:resultDic]);
//         }
//         
//     }
//                            failure:^(NSError *error)
//     {
//         failure(error);
//     }];

}


@end
