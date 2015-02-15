//
//  HouseTableViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseFilter.h"

typedef NS_ENUM(NSInteger, HOUSER_CONTROLLER_TYPE)
{
    HCT_RENT    = 1,
    HCT_SELL     = 2,
};

@interface HouseTableViewController : UITableViewController

@property (nonatomic) HOUSER_CONTROLLER_TYPE controllerType;
@property (nonatomic) HouseFilter *filter;
@property (nonatomic, weak) id container;
- (void)refreshData;

@end
