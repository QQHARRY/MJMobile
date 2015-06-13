//
//  MJKeywordPersistence.m
//  MJ
//
//  Created by harry on 15/6/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJKeywordPersistence.h"
#import "MJKeywordManager.h"



@implementation MJKeywordPersistenceFactory

+(id<MJKeywordPersistence>)getPersistenceImp
{
    return [MJKeywordManager sharedInstance];
}

@end


