//
//  CheckNewVersion.m
//  MJ
//
//  Created by harry on 14/12/20.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "CheckNewVersion.h"
#import "updateDataPuller.h"
#import "UtilFun.h"
#import <PgySDK/PgyManager.h>

#define NEWVERSION_CODE_PRE @"newversion_code"
#define NEWVERSION_REQUIRED_PRE @"newversion_required"
#define NEWVERSION_ADDRESS_PRE @"newversion_address"



@implementation CheckNewVersion

-(void)checkNewVersion:( UIViewController<updateDelegate>*)vc;
{
    self.delegate = vc;
    
    //[self updateVersionInfo];
    [self checkUpdateUsingPgy];
}

-(void)checkUpdateUsingPgy
{
    [[PgyManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}

- (void)updateMethod:(NSDictionary *)response
{
//    appUrl = "http://www.pgyer.com/HVAS";
//    build = 1;
//    downloadURL = "itms-services://?action=download-manifest&url=https://ssl.pgyer.com/app/plist/2aecd923b6095c05558663f7f6506152";
//    lastBuild = 1;
//    releaseNote = "\U66f4\U65b0\U5230\U7248\U672c: 1.1.1.0(build1)";
//    versionCode = 6;
//    versionName = "1.1.1.0";
    
    if (response != nil)
    {
        NSString*versionName = [response objectForKey:@"versionName"];
        NSString*updateNow = @"1";
        NSString*versionAddress = [response objectForKey:@"downloadURL"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setValue:versionName forKey:NEWVERSION_CODE_PRE];
        [prefs setValue:updateNow forKey:NEWVERSION_REQUIRED_PRE];
        [prefs setValue:versionAddress forKey:NEWVERSION_ADDRESS_PRE];
        [prefs synchronize];
        
        [self checkVersion];
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate hasNewVersion:NO VersionName:@"" VersionSize:@"" VersionAddress:@"" RequiredToUpdate:NO];
        }
    }
    
}

-(void)updateVersionInfo
{
    SHOWHUD_WINDOW;
    [updateDataPuller pullNewVersionSuccess:^(versionInfo *vInfo)
     {
         HIDEHUD_WINDOW;
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs setValue:vInfo.VersionName forKey:NEWVERSION_CODE_PRE];
         [prefs setValue:vInfo.UpdateNow forKey:NEWVERSION_REQUIRED_PRE];
         [prefs setValue:vInfo.VersionAddress forKey:NEWVERSION_ADDRESS_PRE];
         [prefs synchronize];
         [self checkVersion];
     } failure:^(NSError *error) {
         HIDEHUD_WINDOW;
     }];
}


-(void)checkVersion
{
    NSString*actualVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    //actualVersion = [NSString stringWithFormat:@"V%@",actualVersion];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString*requiredVersion =[prefs stringForKey:NEWVERSION_CODE_PRE];
    NSString*versionAddress = [prefs stringForKey:NEWVERSION_ADDRESS_PRE];
    NSString*required =[prefs stringForKey:NEWVERSION_REQUIRED_PRE];
    
    BOOL updateRequired = [[required stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"];
    
    if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending)
    {
        
        if (self.delegate)
        {
            [self.delegate hasNewVersion:YES VersionName:requiredVersion VersionSize:@"" VersionAddress:versionAddress RequiredToUpdate:updateRequired];
        }
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate hasNewVersion:NO VersionName:@"" VersionSize:@"" VersionAddress:@"" RequiredToUpdate:NO];
        }
    }

}



@end
