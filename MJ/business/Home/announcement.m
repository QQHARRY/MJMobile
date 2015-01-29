//
//  announcement.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "announcement.h"
#import "person.h"
#import "Macro.h"
#import "NetWorkManager.h"

@implementation announcement


@synthesize  notice_title;
@synthesize  notice_no;
@synthesize  notice_content;
@synthesize  issue_date;
@synthesize  Brief;
@synthesize  isNew;
@synthesize  issue_person_name;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.isNew = FALSE;
    }
    return self;
}


@end
