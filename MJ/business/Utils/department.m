//
//  department.m
//  MJ
//
//  Created by harry on 14/12/15.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "department.h"



static unit*rootUnit = nil;

@implementation department


-(id)init
{
    self = [super init];
    if (self)
    {
        self.isDept = YES;
    }
    return self;
}

+(unit*)rootUnit
{
    
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        rootUnit = [[self alloc] init];
        ((department*)rootUnit).dept_current_no = @"0";
        rootUnit.level = 0;
    });
    return rootUnit;
    
}
@end
