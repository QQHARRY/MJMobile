//
//  HouseViewController.h
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

typedef NS_ENUM(NSInteger, HOUSER_CONTROLLER_TYPE)
{
    HCT_RENT    = 1,
    HCT_SELL     = 2,
};

@interface HouseViewController : ViewPagerController
    <ViewPagerDataSource, ViewPagerDelegate>

@end

