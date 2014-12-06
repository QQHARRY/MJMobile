//
//  UtilFun.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "UtilFun.h"

@implementation UtilFun


+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)action Sender:(UIViewController*)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:action
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [sender presentViewController:alert animated:YES completion:nil];
}

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)actionTitle Handler:(void (^)(UIAlertAction *action))handle Sender:(UIViewController*)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:actionTitle
                                              style:UIAlertActionStyleDefault
                                            handler:handle]];
    
    [sender presentViewController:alert animated:YES completion:nil];
}

+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg Actions:(NSArray*)actArr Sender:(UIViewController*)sender
{
    
}



+(void)setFirstBinded;
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"FirstBinding"];
    [prefs synchronize];
}

+(BOOL)hasFirstBinded;
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL firstBinded =[prefs boolForKey:@"FirstBinding"];
    return firstBinded;
}
@end
