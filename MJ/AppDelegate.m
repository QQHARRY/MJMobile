//
//  AppDelegate.m
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AppDelegate.h"
#import "UtilFun.h"
#import "LoginViewController.h"
#import "UMessage.h"

#import "NetWorkManager.h"
#import "UtilFun.h"
#import "person.h"
#import "Macro.h"
#import "pushManagement.h"
#import "AppDelegate+EaseMob.h"
#import "photoManager.h"
#import "ApplyViewController.h"
#import "EaseMobFriendsManger.h"
#import <PgySDK/PgyManager.h>




#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@interface AppDelegate ()
{
    pushManagement*pushMan;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    if (![UtilFun hasFirstBinded])
    {
        [self loadBindStory];
    }
    else
    {
        [self loadMainSotry:YES];
    }

    [self initUMengPush:launchOptions];
    [self initPGY];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [self logoutEasemob];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


-(void)initPGY
{
#ifdef PRODUCTIONENV
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"ad25e17fbef2bd2033e1a4c7a415861c"];
    
#else
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"0902eb25a35f290f23aeac8b6e5786c0"];
    
#endif
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
}


-(void)logoutEasemob
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        NSLog(@"logout arealdy");
    } onQueue:nil];
}

-(void)loginStateChange:(NSNotification *)notification
{
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    NSLog(@"loginStateChanged isAutoLogin=:%d loginSuccess=%d",isAutoLogin,loginSuccess);
    

    
    
    if (!isAutoLogin && !loginSuccess)
    {
        [self loginToEaseMob:nil ReloadData:NO];
    }
    else
    {
        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
    }
}



-(void)loginToEaseMob:(void (^)(BOOL loginSuccess))success ReloadData:(BOOL)reload
{
    NSString*easeMobAcc = [[person me].job_no  lowercaseString];
    NSString*easeMobPwd = [LoginViewController getEasePwd];
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    
    
     //NSLog(@"loginToEaseMob isAutoLogin=:%d",isAutoLogin);
    if (!isAutoLogin)
    {
        //异步登陆账号
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:easeMobAcc
                                                            password:easeMobPwd
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             
             if (loginInfo && !error)
             {
                 
                 //将旧版的coredata数据导入新的数据库
                 EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                 [[EaseMob sharedInstance].chatManager setApnsNickname:[person me].name_full];
                 if (reload)
                 {
                     
                     //获取群组列表
                     [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                     
                     //设置是否自动登录
                     [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
                     
                     
                     if (!error) {
                         error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                     }
                 }
                 if(success)
                 {
                     success(YES);
                 }
                 
                 
             }
             else
             {
                 if(success)
                 {
                     success(NO);
                 }
//                 switch (error.errorCode)
//                 {
//                     case EMErrorServerNotReachable:
//                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                         break;
//                     case EMErrorServerAuthenticationFailure:
//                         TTAlertNoTitle(error.description);
//                         break;
//                     case EMErrorServerTimeout:
//                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                         break;
//                     default:
//                         TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
//                         break;
//                 }
             }
         } onQueue:nil];

    }
    else
    {
        if (success) {
            
            success(YES);
        }
    }
   
}



-(void)initUMengPush:(NSDictionary *)launchOptions
{
    
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:@"54992c65fd98c5b50700105b" launchOptions:launchOptions];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开APP";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"关闭";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    }
    else
    {
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log 
    //[UMessage setLogEnabled:YES];
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:      [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self setDeviceToken:token];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}


-(void)setDeviceToken:(NSString*)deviceToken
{
    if (pushMan == nil)
    {
        pushMan = [[pushManagement alloc] init];
        
    }
    [pushMan setDeviceToken:deviceToken];
}
-(void)setMemberID:(NSString*)memberID
{
    if (pushMan == nil)
    {
        pushMan = [[pushManagement alloc] init];
        
    }
    [pushMan setMemberID:memberID];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
    NSString*alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    
    UILocalNotification* notify = [[UILocalNotification alloc]init];
    
    notify.fireDate = [[NSDate new] dateByAddingTimeInterval:0];
    notify.alertBody = alert;
    notify.repeatInterval = 0;
    notify.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
    if (_mainController) {
        
        [_mainController jumpToChatList];
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController jumpToChatList];
    }
}

-(void)loadBindStory
{
    _curStory = [UIStoryboard storyboardWithName:@"bind" bundle:[NSBundle mainBundle]];
    
    self.window.rootViewController=[_curStory instantiateInitialViewController];
}
-(void)loadMainSotry:(BOOL)autoLogin
{
    _curStory = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    LoginViewController*login =[_curStory instantiateInitialViewController];
    if ([login  isKindOfClass:[LoginViewController class]])
    {
        login.autoLogin = autoLogin;
    }
   
    
    self.window.rootViewController=login;
}

-(id)instantiateViewControllerWithIdentifier:(NSString*)identifier AndClass:(Class)cls
{
    if (identifier != nil && identifier.length > 0 && cls != nil)
    {
        id ctrl = [_curStory instantiateViewControllerWithIdentifier:identifier];
        if ([ctrl class] == cls)
        {
            return ctrl;
        }
    }
    
    return nil;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)appLogout
{
    [person cleanMe];
    [photoManager clean];
    self.mainController = nil;
    [self logoutEasemob];
    [[EaseMobFriendsManger sharedInstance] clean];

    
    [self loadMainSotry:NO];
}

@end
