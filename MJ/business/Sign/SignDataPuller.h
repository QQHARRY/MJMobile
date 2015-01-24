//
//  SignDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientFilter.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"


@interface SignDataPuller : NSObject

+(void)pushNewSignWithParam:(NSDictionary *)param Success:(void (^)(NSString *signNo))success failure:(void (^)(NSError *error))failure;
//+(void)pullCustomerListDataSuccess:(void (^)(NSArray *areaList))success failure:(void (^)(NSError *error))failure;
+(void)pullSignConditionListDataSuccess:(void (^)(NSDictionary *conditionSrc))success failure:(void (^)(NSError *error))failure;
+(void)pullClientWithFilter:(ClientFilter *)filter Success:(void (^)(NSArray *clientList))success failure:(void (^)(NSError *error))failure;

@end
