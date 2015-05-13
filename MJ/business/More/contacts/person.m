//
//  person.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "person.h"
#import <objc/runtime.h>
#import "EaseMobFriendsManger.h"

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
-(IMSTATE)imState
{
    IMSTATE state = IM_NOT_OPEN;

    if ([self isImOpened])
    {
        
        state = [[EaseMobFriendsManger sharedInstance] hasFriendWithUserName:self.job_no.uppercaseString]?IM_FRIEND:IM_OPENED_NOT_FRIEND;
    }

    
    return state;
}

-(void)copyInfo:(person*)psn
{
    if (psn && [psn.job_no isEqualToString:self.job_no])
    {
        self.photo = psn.photo;
        self.department_name = psn.department_name;
        self.job_name = psn.job_name;
        self.obj_mobile = psn.obj_mobile;
        self.acc_content = psn.acc_content;
        self.acc_remarks = psn.acc_remarks;
        self.department_no = psn.department_no;
        self.role_name = psn.role_name;
        self.dept_name = psn.dept_name;
        self.technical_post_name = psn.technical_post_name;
        self.members = psn.members;

        
    }
}

@end
