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

#define NEWVERSION_CODE_PRE @"newversion_code"
#define NEWVERSION_REQUIRED_PRE @"newversion_required"
#define NEWVERSION_ADDRESS_PRE @"newversion_address"



@implementation CheckNewVersion

-(void)checkNewVersion:( UIViewController<updateDelegate>*)vc;
{
    self.delegate = vc;
    
    [self updateVersionInfo];
    
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
    actualVersion = [NSString stringWithFormat:@"V%@",actualVersion];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString*requiredVersion =[prefs stringForKey:NEWVERSION_CODE_PRE];
    NSString*versionAddress = [prefs stringForKey:NEWVERSION_ADDRESS_PRE];
    NSString*required =[prefs stringForKey:NEWVERSION_REQUIRED_PRE];
    
    BOOL updateRequired = [[required stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"true"];
    
    if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending)
    {
        
        if (self.delegate)
        {
            [self.delegate hasNewVersion:YES VersionName:requiredVersion VersionSize:@"" VersionAddress:versionAddress RequiredToUpdate:updateRequired];
        }
        
        
        //if ([self isNewVersionRequired])
        {
            NSString*versionPromot = [[NSString alloc] initWithFormat:@"版本号:%@\r\n当前版本将不再可用",requiredVersion];
            if (self.delegate)
            {
                
//                PRESENTALERTWITHHANDER(NEWVERSION_REQUIRED_PROMOT, versionPromot, @"现在更新",self.delegate,^(UIAlertAction *action)
//                                       {
//                                           
//                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionAddress]];
//                                       }
//                                       );
            }
            
        }
        //else
        {
            NSString*versionPromot = [NSString stringWithFormat:@"版本号:%@\r\n建议您更新到最新版本",requiredVersion];
//            if (self.delegate)
//            {
//                PRESENTALERTWITHHANDER_WITHDEFAULTCANCEL(NEWVERSION_REQUIRED_PROMOT, versionPromot, @"现在更新",self.delegate,^(UIAlertAction *action)
//                                                         {
//                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionAddress]];
//                                                         }
//                                                         );
//            }
            
        }
        
    }
    else
    {
        if (self.delegate)
        {
            [self.delegate hasNewVersion:NO VersionName:nil VersionSize:nil VersionAddress:nil RequiredToUpdate:NO];
        }
    }
    
}



@end
