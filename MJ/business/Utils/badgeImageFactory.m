//
//  badgeImageFactory.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//


#define BADGEEXTEND 0.65

#import "badgeImageFactory.h"
#import "JSBadgeView.h"

@implementation badgeImageFactory

+(UIImage*)getBadgeImageFromImage:(UIImage*)image andText:(NSString*)txt
{
    UIImageView*imgV = [[UIImageView alloc] initWithImage:image];
    
    CGRect rctOld = [imgV frame];
    [imgV  setFrame:CGRectMake(0, imgV.frame.size.height*(1-BADGEEXTEND), imgV.frame.size.width, imgV.frame.size.height)];
    
    UIView*viewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rctOld.size.width/BADGEEXTEND, rctOld.size.height/BADGEEXTEND)];
    
    
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgV alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText =txt;

    [viewTmp addSubview:imgV];
    
    UIGraphicsBeginImageContext(viewTmp.bounds.size);
    
    [viewTmp.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


+(UIImageView*)getBadgeImageViewFromImage:(UIImage*)image andText:(NSString*)txt
{
    UIImageView*imgV = [[UIImageView alloc] initWithImage:image];
    //CGRect rct = [imgV frame];
    
    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:imgV alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText =txt;
    
    
    
    return imgV;
}


@end
