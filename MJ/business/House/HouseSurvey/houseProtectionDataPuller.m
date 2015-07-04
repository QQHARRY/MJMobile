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
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
             HouseProtectionInfo*info = [[HouseProtectionInfo alloc] init];
             
             [info initWithDictionary:resultDic];
             success(info);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}
@end
