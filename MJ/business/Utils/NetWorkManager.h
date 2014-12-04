//
//  NetWorkManager.h
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol POSTMETHOD <NSObject>

@required
-(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
@end


@interface NetWorkManager : NSObject

+(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;
@end
