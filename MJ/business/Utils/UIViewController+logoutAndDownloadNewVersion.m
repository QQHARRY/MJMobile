//
//  UIViewController+logoutAndDownloadNewVersion.m
//  MJ
//
//  Created by harry on 15/5/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIViewController+logoutAndDownloadNewVersion.h"
#import "AppDelegate.h"
#import "UtilFun.h"


#define NEWVERSION_REQUIRED_PROMOT @"发现一个必须更新的新版本"

@implementation UIViewController (logoutAndDownloadNewVersion)
-(void)quitAndDLNewVersion:(NSString*)vName Address:(NSString*)address
{
    if (address == nil || address.length == 0)
    {
        return;
    }
    NSString*versionPromot = [[NSString alloc] initWithFormat:@"版本号:%@\r\n当前版本将不再可用",vName];
    PRESENTALERTWITHHANDER(NEWVERSION_REQUIRED_PROMOT, versionPromot, @"现在更新",self,^(UIAlertAction *action)
                           {
                               AppDelegate*app = [[UIApplication sharedApplication] delegate];
                               
                               [app appLogout];
                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
                           }
                           );
}
@end
