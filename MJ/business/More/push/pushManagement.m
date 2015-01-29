//
//  pushManagement.m
//  MemberShip
//
//  Created by harry on 14-8-21.
//  Copyright (c) 2014年 harry.he. All rights reserved.
//

#import "pushManagement.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "person.h"
#import "Macro.h"

@implementation pushManagement

@synthesize deviceToken;
@synthesize memberID;

-(void)setDeviceToken:(NSString *)dt
{
    deviceToken = dt;
    if (self.deviceToken != nil && self.memberID != nil)
    {
        [self sendDeviceTokenAndDevice];
    }
}

-(void)setMemberID:(NSString *)memID
{
    memberID = memID;
    if (self.deviceToken != nil && self.memberID != nil)
    {
        [self sendDeviceTokenAndDevice];
    }
}

-(void)sendDeviceTokenAndDevice
{
   
    NSDictionary *parameters = @{
                                 @"job_no":[person me].job_no ,
                                 @"acc_password":[person me].password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"DeviceType" : DEVICE_IOS,
                                 @"DeviceToken" : deviceToken
                                 };
    [NetWorkManager PostWithApiName:REG_PUSH_NOTIFICATION parameters:parameters success:^(id responseObject)
     {
         NSLog(@"regist token success");
         
     }
                            failure:^(NSError *error)
     {
         NSLog(@"regist token fail");
         
     }];
}



@end
