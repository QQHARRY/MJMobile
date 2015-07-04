//
//  houseProtectionDataPuller.h
//  MJ
//
//  Created by harry on 15/7/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "HouseProtectionInfo.h"

@interface houseProtectionDataPuller : bizManager


+(void)pullProtection:(NSString*)trade_no Success:(void(^)(HouseProtectionInfo*))success failure:(void (^)(NSError *error))failure;
@end
