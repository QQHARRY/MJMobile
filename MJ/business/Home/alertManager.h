//
//  alertManager.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bizManager.h"

@interface alertManager : bizManager

+(void)getListReaded:(BOOL)readed From:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;
@end
