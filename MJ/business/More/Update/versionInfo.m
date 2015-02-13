//
//  versionInfo.m
//  MJ
//
//  Created by harry on 15/2/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "versionInfo.h"

@implementation versionInfo

@synthesize Status;
@synthesize VersionName;
//String
//最新版版本号
@synthesize  VersionSize;
//String
//版本大小(单位M)
@synthesize  UpdateNow;
//Bool
//必须更新?提示如果不更新就无法从数据库获取数据
//true 必须更新
//false不必更新
@synthesize  VersionAddress;
//String
//版本更新地址：
//安卓返回URL
//IOS返回APPSTORE地址

@end
