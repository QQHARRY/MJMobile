//
//  bizManager.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "Macro.h"

@implementation bizManager

+(BOOL)checkReturnStatus:(NSDictionary*)resultDic Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure ShouldReturnWhenSuccess:(BOOL)returnS
{

    NSString*Status = [resultDic objectForKey:@"Status"];
    
    
    if (Status == nil || [Status  length] <= 0)
    {
        NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:SERVER_NONCOMPLIANCE_INFO}];
        failure(error);
        return NO;
    }
    else
    {
        NSInteger iStatus = [Status intValue];
        if (iStatus == 0)
        {
            if (returnS)
            {
                success(resultDic);
                
            }
            return YES;
        }
        else
        {
            NSString*strError = [resultDic objectForKey:@"ErrorInfo"];
            NSError*error = [[NSError alloc] initWithDomain:SERVER_NONCOMPLIANCE code:0 userInfo:@{SERVER_NONCOMPLIANCE:strError}];
            failure(error);
            return NO;
        }
        
    }
    return NO;
}


@end
