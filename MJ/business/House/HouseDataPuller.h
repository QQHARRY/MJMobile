//
//  HouseDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseFilter.h"

@interface HouseDataPuller : NSObject

+(void)pullDataWithFilter:(HouseFilter *)filter Success:(void (^)(NSArray *houseDetailList))success failure:(void (^)(NSError *error))failure;

@end
