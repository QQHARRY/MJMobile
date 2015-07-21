//
//  dic2Object.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "dic2Object.h"
#import <objc/runtime.h>

@implementation dic2Object

-(BOOL)initWithDictionary:(NSDictionary*)dic
{
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        NSString *key = [NSString stringWithUTF8String:ivar_getName(*p)];
        NSString*value = [dic objectForKey:key];
        if (value && [value length] > 0)
        {
             object_setIvar(self,*p,value);
        }
        else{
            object_setIvar(self,*p,@"");
        }
       
    }
    
    free(ivars);
    return TRUE;
}


-(NSDictionary*)convert2Dic
{
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    Class cls = [self class];
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        NSString *key = [NSString stringWithUTF8String:ivar_getName(*p)];
        
        id value = object_getIvar(self, *p);
        if (value && [value isKindOfClass:[NSString class]] &&
            ((NSString*)value).length > 0)
        {
            [dic setValue:value forKey:key];
        }
    }
    
    free(ivars);
    
    return dic;
}



@end
