//
//  AppDelegate.h
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EaseMobStatusMonitorDelegate <NSObject>

- (void)setupUntreatedApplyCount;

- (void)networkChanged:(EMConnectionState)connectionState;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;

-(void)loadBindStory;
-(void)loadMainSotry:(BOOL)autoLogin;
-(void)setDeviceToken:(NSString*)deviceToken;
-(void)setMemberID:(NSString*)memberID;

@property (strong, nonatomic)UIStoryboard*curStory;
@property (weak, nonatomic) id<EaseMobStatusMonitorDelegate> mainController;

-(id)instantiateViewControllerWithIdentifier:(NSString*)identifier AndClass:(Class)cls;

-(void)loginToEaseMob:(void (^)(BOOL loginSuccess))success ReloadData:(BOOL)reload;

-(void)appLogout;
@end

