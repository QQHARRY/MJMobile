//
//  UtilFun.h
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//
/*[UtilFun presentPopViewControllerWithTitle:title Message:msg SimpleAction:action Sender:tmpSender];*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SHOWWINDOWHUD(tip) ([UtilFun showWindowHUD:(tip)]);
#define HIDEALLWINDOWHUD ([UtilFun hideAllWindowHUD]);

#define SHOWHUD_WINDOW ([UtilFun showHUD:[UIApplication sharedApplication].keyWindow]);
#define HIDEHUD_WINDOW ([UtilFun hideHUD:[UIApplication sharedApplication].keyWindow]);

#define SHOWHUD(v) ([UtilFun showHUD:v]);
#define HIDEHUD(v) ([UtilFun hideHUD:v]);


#define PRESENTALERT(title,msg,action,hander,sender)\
{\
    id tmpSender = sender;\
    if(sender == nil) tmpSender = self;\
    [UtilFun presentPopViewControllerWithTitle:title Message:msg SimpleAction:action Handler:hander CancelAction:nil  CancelHandler:nil Sender:tmpSender];\
}\


#define PRESENTALERTWITHHANDER_WITHDEFAULTCANCEL(title,msg,action,hander,cancel,cancelHander,sender)\
{\
id tmpSender = sender;\
if(sender == nil) tmpSender = self;\
[UtilFun presentPopViewControllerWithTitle:title Message:msg SimpleAction:action Handler:hander CancelAction:cancel  CancelHandler:cancelHander Sender:tmpSender];\
}\



@interface UtilFun : NSObject

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Handler:(void (^)())handle CancelAction:(NSString*)cancelTitle CancelHandler:(void (^)())cancelHandle Sender:(UIViewController*)sender;


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
