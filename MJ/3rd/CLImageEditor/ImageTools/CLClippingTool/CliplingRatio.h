//
//  CliplingRatio.h
//  MJ
//
//  Created by harry on 15/6/18.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CliplingRatio : NSObject

@property(nonatomic,assign)NSInteger widthSide;
@property(nonatomic,assign)NSInteger heightSide;

+(id)RatioWithWidthSide:(NSInteger)ws andHeightSide:(NSInteger)hs;

@end
