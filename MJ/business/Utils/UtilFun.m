//
//  UtilFun.m
//  MJ
//
//  Created by harry on 14/12/4.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "UtilFun.h"
#import "MBProgressHUD.h"
#import "sys/utsname.h"
#import "WCAlertView.h"

static NSString*UDIDSTRING=nil;

@implementation UtilFun


+(void)presentPopViewControllerWithTitle:(NSString*)title Message:(NSString*)msg SimpleAction:(NSString*)actionTitle Handler:(void (^)())handle CancelAction:(NSString*)cancelTitle CancelHandler:(void (^)())cancelHandle Sender:(UIViewController*)sender
{
    if (actionTitle == nil || actionTitle.length == 0) {
        actionTitle = @"OK";
    }
    [WCAlertView showAlertWithTitle:title message:msg customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        switch (buttonIndex)
        {
            case 0:
            {
                if (handle)
                {
                    handle();
                }
            }
                break;
            case 1:
            default:
            {
                if (cancelHandle)
                {
                    cancelHandle();
                }
            }
                break;
        }
    } cancelButtonTitle:actionTitle otherButtonTitles:cancelTitle, nil];

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

+(void)showWindowHUD:(NSString *)tip
{
    UIView *v = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:v];
    hud.labelText = tip;
    [v addSubview:hud];
    [hud show:YES];
}

+(void)showHUD:(NSString *)tip View:(UIView*)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelText = tip;
    [view addSubview:hud];
    [hud show:YES];
}

+(void)hideAllWindowHUD
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+(void)showHUD:(UIView*)view
{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+(void)hideHUD:(UIView*)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(void)hideAllHUD:(UIView*)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+(NSString*)getUDID
{
    
    if (UDIDSTRING == nil)
    {
        NSString*tmp = [self getUDIDFromPre];
        if (tmp)
        {
            UDIDSTRING = tmp;
        }
        else
        {
            UDIDSTRING = [self genUUID];
            
            [self setUDIDToPre:UDIDSTRING];
        }
    }
    //return @"justfortest";
    return UDIDSTRING;
}
+(void)setUDIDToPre:(NSString*)string
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:string forKey:@"MEIJIAUDID"];
    [prefs synchronize];
}

+(NSString*)getUDIDFromPre;
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString*str =[prefs stringForKey:@"MEIJIAUDID"];
    return str;
}


+(NSString*)genUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

+(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+(BOOL)isIphoneAboutHardWare
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
//    NSString*strModel =  [UIDevice currentDevice].model;
    
    return [deviceString  rangeOfString:@"iPhone"].location != NSNotFound;
}

+(BOOL)isIphoneAboutUI
{
    NSString*strModel =  [UIDevice currentDevice].model;
    
    return [strModel  rangeOfString:@"iPhone"].location != NSNotFound;
}

+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
