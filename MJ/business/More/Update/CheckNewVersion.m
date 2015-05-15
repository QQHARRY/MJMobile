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
    if (response != nil)
    {
        NSString*newVersion = [response objectForKey:@"versionName"];
        NSString*versionAddress = [response objectForKey:@"downloadURL"];
        NSString* releaseNote = [response objectForKey:@"releaseNote"];
        
        NSString*nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        
        if ([newVersion compare:nowVersion options:NSNumericSearch] == NSOrderedDescending)
        {
            
            if (self.delegate)
            {
                [self.delegate hasNewVersion:YES VersionName:newVersion ReleaseNote:releaseNote VersionSize:@"" VersionAddress:versionAddress RequiredToUpdate:YES];
                return;
            }
        }
    }

    if (self.delegate)
    {
        [self.delegate hasNewVersion:NO VersionName:@"" ReleaseNote:@"" VersionSize:@"" VersionAddress:@"" RequiredToUpdate:NO];
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
            [self.delegate hasNewVersion:YES VersionName:requiredVersion  ReleaseNote:@"" VersionSize:@"" VersionAddress:versionAddress RequiredToUpdate:updateRequired];
        }
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate hasNewVersion:NO VersionName:@"" ReleaseNote:@"" VersionSize:@"" VersionAddress:@"" RequiredToUpdate:NO];
        }
    }

}



@end
