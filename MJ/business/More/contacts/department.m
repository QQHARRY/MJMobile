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
@synthesize dept_current_no;
@synthesize dept_name;
@synthesize dept_parent_no;
@synthesize dept_type;

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
        ((department*)rootUnit).dept_name=@"";
    });
    return rootUnit;
    
}

-(BOOL)isCompany
{
    return [self.dept_type isEqualToString:@"1"];
}


@end
