//
//  photoManager.m
//  MJ
//
//  Created by harry on 15/2/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "photoManager.h"
__strong static photoManager* _sharedObject = nil;


@implementation photoManager



;
+(photoManager*)sharedInstance
{
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        _sharedObject.photoDic = [[NSMutableDictionary alloc] init];
    });
    
    return _sharedObject;
}

+(void)setPhoto:(UIImage*)photo ForPerson:(person*)psn
{
    if (photo && psn)
    {
        NSString*key = [NSString stringWithFormat:@"%@",psn];
        photoManager*manager = [photoManager sharedInstance];
        [manager.photoDic setValue:photo forKey:key];
    }
    
}

+(UIImage*)getPhotoByPerson:(person*)psn
{
    if (psn)
    {
        photoManager*manager = [photoManager sharedInstance];
        NSString*key = [NSString stringWithFormat:@"%@",psn];
        return [manager.photoDic objectForKey:key
                ];
    }
    return nil;
}

+(void)clean
{
    photoManager*manager = [photoManager sharedInstance];
    [manager.photoDic removeAllObjects];
}
@end
