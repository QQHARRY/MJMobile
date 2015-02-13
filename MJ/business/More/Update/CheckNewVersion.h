//
//  CheckNewVersion.h
//  MJ
//
//  Created by harry on 14/12/20.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "versionInfo.h"
#define NEWVERSION_PROMPT @"有一个新版本可以更新"
#define NEWVERSION_REQUIRED_PROMOT @"有一个必须更新的新版本"

@protocol updateDelegate <NSObject>

@required
-(void)hasNewVersion:(BOOL)bHasNewVersion VersionName:(NSString*)vName VersionSize:(NSString*)size VersionAddress:(NSString*)address RequiredToUpdate:(BOOL)updateRequired;
@end

@interface CheckNewVersion : NSObject


@property(weak,nonatomic) UIViewController<updateDelegate>*delegate;
-(void)checkNewVersion:( UIViewController<updateDelegate>*)vc;

@end
