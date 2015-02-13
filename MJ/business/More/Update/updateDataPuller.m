//
//  updateDataPuller.m
//  MJ
//
//  Created by harry on 15/2/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "updateDataPuller.h"
#import "person.h"
#import "Macro.h"
#import "NetWorkManager.h"

@implementation updateDataPuller

+(void)pullNewVersionSuccess:(void (^)(versionInfo *vInfo))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password":[person me].password,
                                 @"DeviceType" : DEVICE_IOS,
                                 };
    
    
    [NetWorkManager PostWithApiName:API_CHECK_NEW_VERSION parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         versionInfo*vInfo = [[versionInfo alloc] init];
         //[vInfo initWithDictionary:[[resultDic objectForKey:@"EstateBuildingsDetailsNode"] objectAtIndex:0]];
         [vInfo initWithDictionary:resultDic];
         if ([vInfo.Status intValue] != 0)
         {
             failure(nil);
         }
         else
         {

             //vInfo.VersionAddress= @"https://itunes.apple.com/cn/app/cad-viewer-gstarcad-mc-pro/id555578651?mt=8";

             success(vInfo);
         }
         
         
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];
}
@end
