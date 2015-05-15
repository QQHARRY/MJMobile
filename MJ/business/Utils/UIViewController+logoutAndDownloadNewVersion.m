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


@interface UIViewController()<UITableViewDelegate>



@end

#define NEWVERSION_REQUIRED_PROMOT @"发现一个必须更新的新版本"

@implementation UIViewController (logoutAndDownloadNewVersion)
-(void)quitAndDLNewVersion:(NSString*)vName ReleaseNote:(NSString *)releaseNote Address:(NSString*)address
{
    if (address == nil || address.length == 0)
    {
        return;
    }
    NSString*versionPromot = [[NSString alloc] initWithFormat:@"发现新版本:%@\r\n当前版本不再可用",vName];
    NSString*releaseNoteStr = [NSString stringWithFormat:@"更新说明:\r\n%@",releaseNote];
    PRESENTALERTWITHHANDER(versionPromot, releaseNoteStr, @"现在更新",self,^(UIAlertAction *action)
                           {
                               AppDelegate*app = [[UIApplication sharedApplication] delegate];
                               
                               [app appLogout];
                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
                           }
                           );
    
//    UIAlertView*alert =[[UIAlertView alloc] initWithTitle:versionPromot message:releaseNoteStr delegate:self cancelButtonTitle:@"现在更新" otherButtonTitles:nil, nil];
//    
//    [alert show];

}

//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//    if (alertView)
//    {
//        int intFlg = 0 ;//先是title intFlg = 0，当intFlg =1;message label
//        for( UIView * view in [alertView subviews] )
//        {
//            if( [view isKindOfClass:[UILabel class]] )
//            {
//                UILabel* label = (UILabel*) view;
//                if(intFlg == 1)
//                {
//                    label.textAlignment = UITextAlignmentLeft;
//                }
//                intFlg = 1;
//            }
//            
//        }
//    }
//    
//}


@end
