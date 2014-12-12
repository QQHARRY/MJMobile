//
//  bizManager.h
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bizManager : NSObject

+(BOOL)checkReturnStatus:(NSDictionary*)resultDic Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure ShouldReturnWhenSuccess:(BOOL)returnS;

@end
