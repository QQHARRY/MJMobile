//
//  HouseProtectionInfo.h
//  MJ
//
//  Created by harry on 15/7/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface HouseProtectionInfo : dic2Object

@property(strong,nonatomic)NSString*Status;
@property(strong,nonatomic)NSString*leftH;
@property(strong,nonatomic)NSString*leftM;

-(BOOL)isInProtection;
-(NSString*)getProtectionInfo;
@end
