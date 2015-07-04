//
//  FollowDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseFilter.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"


@interface FollowDataPuller : NSObject

+(void)pullDataWithFilter:(NSString *)sid Success:(void (^)(NSArray *followList))success failure:(void (^)(NSError *error))failure;
+(void)pushNewFollowWithParam:(NSDictionary *)param Success:(void (^)(NSString *followNo))success failure:(void (^)(NSError *error))failure;

+(void)pullPrivLog:(NSString*)trade_no Success:(void (^)(NSString*privNo))success failure:(void (^)(NSError *error))failure;

@end
