//
//  ContactDataProvider.h
//  MJ
//
//  Created by harry on 15/4/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "bizManager.h"

@interface ContactDataProvider : bizManager

#if 0
+(void)searchUnitByKeyWord:(NSString *)kw Success:(void (^)(NSArray *personArr,NSArray*dptArr))success failure:(void (^)(NSError *error))failure;
#endif

@end
