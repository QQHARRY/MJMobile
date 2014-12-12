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

//-(BOOL)initWithDictionary:(NSDictionary*)dic
//{
//    Class cls = [self class];
//    unsigned int ivarsCnt = 0;
//    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
//
//    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
//    {
//        //Ivar const ivar = ;
//        NSString *key = [NSString stringWithUTF8String:ivar_getName(*p)];
//        NSString*value = [dic objectForKey:key];
//        if ([value length] == 0)
//        {
//            value = nil;
//        }
//        object_setIvar(self,*p,value);
//    }
//
//    return TRUE;
//}




+(person*)initMe:(NSDictionary*)dic
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject initWithDictionary:dic];
    });
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
        object_setIvar(self,*p,nil);
    }
}

@end
