//
//  EaseMobContacter.m
//  MJ
//
//  Created by harry on 15/5/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "EaseMobContacter.h"

@implementation EaseMobContacter

-(id)initWithBuddy:(EMBuddy*)buddy Person:(person*)psn
{
    self = [super init];
    if (self)
    {
        self.buddy = buddy;
        self.psn = psn;
        
        _requestBlock = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

@end
