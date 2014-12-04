//
//  UtilFun.h
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilFun : NSObject

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Sender:(UIViewController*)sender;
+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg Actions:(NSArray*)actArr Sender:(UIViewController*)sender;
@end
