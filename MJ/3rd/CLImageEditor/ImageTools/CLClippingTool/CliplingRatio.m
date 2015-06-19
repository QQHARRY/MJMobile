//
//  CliplingRatio.m
//  MJ
//
//  Created by harry on 15/6/18.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "CliplingRatio.h"

@implementation CliplingRatio

+(id)RatioWithWidthSide:(NSInteger)ws andHeightSide:(NSInteger)hs
{
    CliplingRatio*ratio = [[super alloc] init];
    if (ratio)
    {
        ratio.widthSide = ws;
        ratio.heightSide = hs;
    }
    
    return ratio;
}

@end
