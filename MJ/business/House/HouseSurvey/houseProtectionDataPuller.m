//
//  houseProtectionDataPuller.m
//  MJ
//
//  Created by harry on 15/7/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "houseProtectionDataPuller.h"
#import "AFNetworking.h"
#import "NetWorkManager.h"
#import "Macro.h"

@implementation houseProtectionDataPuller

+(void)pullProtection:(NSString*)trade_no Success:(void(^)(HouseProtectionInfo*))success failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:trade_no forKey:@"trade_no"];

    
    [NetWorkManager PostWithApiName:API_GET_PROTECTION_INFO parameters:param success:^(id responseObject)
     {
         //NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             HouseProtectionInfo*info = [[HouseProtectionInfo alloc] init];
             [info initWithDictionary:resultDic];
             success(info);
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}
@end
