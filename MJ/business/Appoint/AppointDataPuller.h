//
//  AppointDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseFilter.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"


@interface AppointDataPuller : NSObject

+(void)pullDataWithFilter:(NSString *)sid Success:(void (^)(NSArray *AppointList))success failure:(void (^)(NSError *error))failure;

@end
