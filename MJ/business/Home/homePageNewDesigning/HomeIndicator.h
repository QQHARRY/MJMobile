//
//  HomeIndicatorCount.h
//  MJ
//
//  Created by harry on 15/5/21.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"
#import "BannerData.h"

@interface HomeIndicator : dic2Object


@property(nonatomic,assign)NSInteger follow_count;
@property(nonatomic,assign)NSInteger alert_count;
@property(nonatomic,assign)NSInteger appoint_count;
@property(nonatomic,assign)CGFloat pert_sum;
@property(nonatomic,assign)NSInteger petition_count;
@property(nonatomic,assign)NSInteger msg_count;

@property(nonatomic,strong)NSMutableArray*bannerDataArr;
@end
