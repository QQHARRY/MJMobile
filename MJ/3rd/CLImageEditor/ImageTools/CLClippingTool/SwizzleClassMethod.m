//
//  SwizzleClassMethod.m
//  MJ
//
//  Created by harry on 15/6/17.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "SwizzleClassMethod.h"
#import <objc/runtime.h>





BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store)
{
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}

