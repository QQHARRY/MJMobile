//
//  UtilFun.h
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SHOWWINDOWHUD(tip) ([UtilFun showWindowHUD:(tip)]);
#define HIDEALLWINDOWHUD ([UtilFun hideAllWindowHUD]);

#define SHOWHUD_WINDOW ([UtilFun showHUD:[UIApplication sharedApplication].keyWindow]);
#define HIDEHUD_WINDOW ([UtilFun hideHUD:[UIApplication sharedApplication].keyWindow]);

#define SHOWHUD(v) ([UtilFun showHUD:v]);
#define HIDEHUD(v) ([UtilFun hideHUD:v]);
#define PRESENTALERT(title,msg,action,sender)\
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)\
{\
    id tmpSender = sender;\
    if(sender == nil) tmpSender = self;\
    [UtilFun presentPopViewControllerWithTitle:title Message:msg SimpleAction:action Sender:tmpSender];\
}\
else\
{\
    NSString*okBtn = @"好的";\
    if(action != nil) okBtn = action;\
    UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:sender cancelButtonTitle:okBtn otherButtonTitles:nil, nil];\
    id tmpSender = sender;\
    if(sender == nil) tmpSender = self;\
    alertView.delegate = tmpSender;\
    [alertView show];\
}\


#define PRESENTALERTWITHHANDER(title,msg,action,sender,hander)\
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)\
{\
[UtilFun presentPopViewControllerWithTitle:title Message:msg SimpleAction:action Handler:hander Sender:sender];\
}\
else\
{\
UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:sender cancelButtonTitle:action otherButtonTitles:nil, nil];\
alertView.delegate = self;\
[alertView show];\
}\


#define PRESENTALERTWITHHANDER_WITHDEFAULTCANCEL(title,msg,action,sender,hander)\
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)\
{\
[UtilFun presentPopViewControllerWithTitle1:title Message:msg SimpleAction:action Handler:hander Sender:sender];\
}\
else\
{\
UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:sender cancelButtonTitle:action otherButtonTitles:@"取消", nil];\
alertView.delegate = self;\
[alertView show];\
}\


@interface UtilFun : NSObject

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Sender:(UIViewController*)sender;
+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Handler:(void (^)(UIAlertAction *action))handle Sender:(UIViewController*)sender;
+(void)presentPopViewControllerWithTitle1:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Handler:(void (^)(UIAlertAction *action))handle Sender:(UIViewController*)sender;
+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg Actions:(NSArray*)actArr Sender:(UIViewController*)sender;


+(void)setFirstBinded;
+(BOOL)hasFirstBinded;

+(void)showHUD:(UIView*)view;
+(void)hideHUD:(UIView*)view;
+(void)hideAllHUD:(UIView*)view;
+(void)showWindowHUD:(NSString *)tip;
+(void)hideAllWindowHUD;

+(NSString*)getUDID;


+(BOOL)isPureInt:(NSString*)string;
+(BOOL)isPureFloat:(NSString*)string;


+(BOOL)isIphoneAboutHardWare;
+(BOOL)isIphoneAboutUI;

+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

@end
