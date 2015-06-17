//
//  MJKeywordManager.m
//  MJ
//
//  Created by harry on 15/6/13.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "MJKeywordManager.h"

@implementation MJKeywordManager


__strong static id _sharedObject = nil;


+ (id<MJKeywordPersistence>)sharedInstance
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(NSArray*)getHistoryKeyWordByKey:(NSString*)key
{
    NSMutableArray*arr = [[NSMutableArray alloc] init];
    if (key != nil && [key length] != 0)
    {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        id keys = [prefs valueForKey:key];
        if (keys)
        {
            [arr addObjectsFromArray:keys];
        }

    }
    return arr;
}
-(void)synHistoryKeyWordArr:(NSMutableArray*)arr ByKey:(NSString*)key
{
    if (arr && key != nil && [key length] != 0)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

        [prefs setValue:arr forKey:key];
        [prefs synchronize];

    }
}

-(void)clearHistoryKeyWordArrByKey:(NSString*)key
{
    if (key != nil && [key length] != 0)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setValue:nil forKey:key];
        [prefs synchronize];
        
    }
}

@end
