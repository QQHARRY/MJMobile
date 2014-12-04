//
//  UtilFun.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "UtilFun.h"

@implementation UtilFun


+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)actionTitle Sender:(UIViewController*)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:actionTitle
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    
    [sender presentViewController:alert animated:YES completion:nil];
}
+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg Actions:(NSArray*)actArr Sender:(UIViewController*)sender
{
    
}
@end
