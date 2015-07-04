//
//  HouseProtectionInfo.m
//  MJ
//
//  Created by harry on 15/7/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseProtectionInfo.h"

@implementation HouseProtectionInfo


@synthesize Status;
@synthesize leftH;
@synthesize leftM;


-(BOOL)isInProtection
{
    return [self.Status intValue] == 2;
}

-(NSString*)getProtectionInfo
{
    return [NSString stringWithFormat:@"保护时间剩余:%@小时%@分钟",self.leftH,self.leftM];
}

@end
