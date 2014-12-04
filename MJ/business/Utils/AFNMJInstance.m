//
//  AFNMJInstance.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AFNMJInstance.h"
#import "Macro.h"

@implementation AFNMJInstance

+(id<POSTMETHOD>)instance
{
    return [[AFNMJInstance alloc] init];
}


-(void)PostWithApiName:(NSString*)apiName parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, API_REG] parameters:parameters success:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (success)
         {
             success(responseObject);
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if (failure)
         {
             failure(error);
         }
     }
     ];
}
@end
