//
//  UtilFun.h
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define SHOWHUD(v) ([UtilFun showHUD:v]);
#define HIDEHUD(v) ([UtilFun hideHUD:v]);


@interface UtilFun : NSObject

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Sender:(UIViewController*)sender;
+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Handler:(void (^)(UIAlertAction *action))handle Sender:(UIViewController*)sender;

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg Actions:(NSArray*)actArr Sender:(UIViewController*)sender;


+(void)setFirstBinded;
+(BOOL)hasFirstBinded;

+(void)showHUD:(UIView*)view;
+(void)hideHUD:(UIView*)view;
+(void)hideAllHUD:(UIView*)view;

+(NSString*)getUDID;

@end
