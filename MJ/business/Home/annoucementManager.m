//
//  annoucementManager.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "annoucementManager.h"
#import "person.h"
#import "Macro.h"
#import "NetWorkManager.h"

@implementation annoucementManager

+(void)getListFrom:(NSString*)from To:(NSString*)to Count:(int)count Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"FromID":from,
                                 @"ToID":to,
                                 @"Count":[NSNumber numberWithInt:count]
                                 };
    
    
    [NetWorkManager PostWithApiName:API_PETITION_LIST parameters:parameters success:
     ^(id responseObject)
     {
         
         [self checkReturnStatus:responseObject Success:success failure:failure ShouldReturnWhenSuccess:YES];
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}
@end
