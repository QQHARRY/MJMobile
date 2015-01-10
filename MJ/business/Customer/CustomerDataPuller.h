//
//  CustomerDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerFilter.h"

@interface CustomerDataPuller : NSObject

+(void)pullDataWithFilter:(CustomerFilter *)filter Success:(void (^)(NSArray *CustomerDetailList))success failure:(void (^)(NSError *error))failure;
//+(void)pullAreaListDataSuccess:(void (^)(NSArray *areaList))success failure:(void (^)(NSError *error))failure;

@end
