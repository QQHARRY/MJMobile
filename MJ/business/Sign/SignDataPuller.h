//
//  SignDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseFilter.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"


@interface SignDataPuller : NSObject

+(void)pushNewSignWithParam:(NSDictionary *)param Success:(void (^)(NSString *att))success failure:(void (^)(NSError *error))failure;

@end
