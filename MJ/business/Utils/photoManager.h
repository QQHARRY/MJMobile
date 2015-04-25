//
//  photoManager.h
//  MJ
//
//  Created by harry on 15/2/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "person.h"

@interface photoManager : NSObject




@property(strong,nonatomic)NSMutableDictionary*photoDic;

+(void)setPhoto:(UIImage*)photo ForPerson:(person*)psn;

+(UIImage*)getPhotoByPerson:(person*)psn;
+(void)clean;
@end
