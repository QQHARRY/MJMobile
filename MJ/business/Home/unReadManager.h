//
//  unReadManager.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unReadManager : NSObject


+(void)setUnReadMessageCount:(int)count;
+(void)setUnReadAlertCnt:(int)count;
+(int)unReadAlertCnt;
+(int)unReadMessageCount;


+(void)getUnReadAlertCntSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
+(void)getUnReadMessageCntSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

@end
