//
//  SwizzleClassMethod.h
//  MJ
//
//  Created by harry on 15/6/17.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef IMP *IMPPointer;
BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store);