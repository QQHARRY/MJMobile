//
//  badgeImageFactory.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface badgeImageFactory : NSObject

+(UIImage*)getBadgeImageFromImage:(UIImage*)image andText:(NSString*)txt;
+(UIImageView*)getBadgeImageViewFromImage:(UIImage*)image andText:(NSString*)txt;

@end
