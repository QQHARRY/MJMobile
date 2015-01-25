//
//  CustomerDataPuller.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerFilter.h"
#import "CustomerDetail.h"
#import "CustomerParticulars.h"
#import "CustomerSecret.h"

@interface CustomerDataPuller : NSObject

+(void)pullDataWithFilter:(CustomerFilter *)filter Success:(void (^)(NSArray *CustomerDetailList))success failure:(void (^)(NSError *error))failure;
+(void)pullCustomerParticulars:(CustomerDetail *)detail Success:(void(^)(CustomerParticulars *particulars))success failure:(void (^)(NSError *error))failure;
+(void)pullCustomerSecret:(CustomerDetail *)detail Success:(void(^)(CustomerSecret *secret))success failure:(void (^)(NSError *error))failure;

@end
