//
//  person.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "person.h"
#import <objc/runtime.h>

__strong static person* _sharedObject = nil;

@implementation person

@synthesize job_no;
@synthesize name_full;
@synthesize company_name;
@synthesize department_name;
@synthesize job_name;
@synthesize obj_mobile;
@synthesize acc_remarks;
@synthesize acc_content;
@synthesize photo;
@synthesize password;
@synthesize department_no;
@synthesize role_name;
@synthesize dept_name;
@synthesize technical_post_name;
@synthesize members;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.isDept = NO;
    }
    return self;
}


+(person*)initMe:(NSDictionary*)dic
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    [_sharedObject initWithDictionary:dic];
    return _sharedObject;
}

+(person*)me
{
    return _sharedObject;
}


+(void)cleanMe
{
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        object_setIvar(_sharedObject,*p,nil);
    }
}

-(BOOL)isImOpened
{
    return [self.members isEqualToString:@"1"];
}
-(IMSTATE)imState:(NSArray*)friendArr
{
    if (![self isImOpened])
    {
        return IM_NOT_OPEN;
    }
    else
    {
        if (friendArr == nil)
        {
            return IM_OPENED_NOT_FRIEND;
        }
        else
        {
            for (person* psn in friendArr)
            {
                if ([psn.job_no isEqualToString:self.job_no])
                {
                    return IM_FRIEND;
                }
                
            }
            return  IM_OPENED_NOT_FRIEND;
        }
    }
    return IM_NOT_OPEN;
}

@end
