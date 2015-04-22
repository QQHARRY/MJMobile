//
//  UIImage+xtRoundedRectImage.h
//  MJ
//
//  Created by harry on 15/4/22.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (xtRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
