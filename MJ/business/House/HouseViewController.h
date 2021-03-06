//
//  HouseViewController.h
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "HouseTableViewController.h"


@interface HouseViewController : ViewPagerController
    <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic) HOUSER_CONTROLLER_TYPE nowControllerType;
@property (nonatomic, strong) HouseTableViewController *rentController;
@property (nonatomic, strong) HouseTableViewController *sellController;
@property (nonatomic, assign) BOOL applyForRefresh;
@end

