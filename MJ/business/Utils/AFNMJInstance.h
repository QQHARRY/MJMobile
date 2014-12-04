//
//  AFNMJInstance.h
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetWorkManager.h"

@interface AFNMJInstance : NSObject<POSTMETHOD>


+(id<POSTMETHOD>)instance;
-(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

@end
