//
//  MJTabbarController.h
//  MJ
//
//  Created by harry on 15/2/14.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MJTabbarController : UITabBarController<UITabBarControllerDelegate,UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate,EaseMobStatusMonitorDelegate>
{
    EMConnectionState _connectionState;
}


- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)jumpToChatList;

@end
