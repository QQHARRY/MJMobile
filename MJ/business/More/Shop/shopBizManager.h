//
//  shopBizManager.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "order.h"

@interface shopBizManager : bizManager

+(void)getListByType:(NSInteger)type From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
+(void)addToCartByBillType:(int)billType GoodID:(NSString*)goodID BillNum:(NSInteger)num  Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
+(void)getOrderListByType:(NSInteger)type From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;
+(void)getAllKindsOrderListByType:(NSInteger)type From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

+(void)cancelOrder:(NSArray*)orderArr Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

+(void)confirmOrder:(NSArray*)orderArr Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;

+(void)receiveOrder:(NSArray*)orderArr Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;

+(void)editOrder:(order*)odr WithNewCount:(NSInteger)newCnt Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure;
@end
