//
//  SignDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "SignDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "bizManager.h"
#import "UtilFun.h"
#import "AFNetworking.h"

@implementation SignDataPuller

+(void)pushNewSignWithParam:(NSDictionary *)param Success:(void (^)(NSString *att))success failure:(void (^)(NSError *error))failure
{
    [NetWorkManager PostWithApiName:API_CREATE_SIGN parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {
//             NSString *src = [resultDic objectForKey:@"Sign_no"];
             NSString *att = [resultDic objectForKey:@"Sign_attachment"];
             success(att);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}

@end
