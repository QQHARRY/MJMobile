//
//  MJCatch.h
//  MJ
//
//  Created by harry on 15/5/5.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "person.h"

@interface MJCatch : NSObject

+(void)storeImage:(UIImage*)image ForKey:(NSString*)key;
+(UIImage*)imageOfKey:(NSString*)key;

@end
