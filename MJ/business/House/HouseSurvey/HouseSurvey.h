//
//  HouseSurvey.h
//  MJ
//
//  Created by harry on 15/6/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "bizManager.h"

@interface HouseSurvey : bizManager

+(void)addHouseSurvery:(NSDictionary*)imageDic Remark:(NSString*)remark Success:(void(^)(id obj))success failure:(void (^)(NSError *error))failure;

@end
