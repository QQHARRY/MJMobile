//
//  versionInfo.h
//  MJ
//
//  Created by harry on 15/2/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface versionInfo : dic2Object

@property(nonatomic,strong)NSString* Status;
@property(nonatomic,strong)NSString* VersionName;
//String
//最新版版本号
@property(nonatomic,strong)NSString* VersionSize;
//String
//版本大小(单位M)
@property(nonatomic,strong)NSString* UpdateNow;
//Bool
//必须更新?提示如果不更新就无法从数据库获取数据
//true 必须更新
//false不必更新
@property(nonatomic,strong)NSString* VersionAddress;
//String
//版本更新地址：
//安卓返回URL
//IOS返回APPSTORE地址

@end
