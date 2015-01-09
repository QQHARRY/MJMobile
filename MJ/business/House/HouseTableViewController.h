//
//  HouseTableViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseViewController.h"
#import "HouseFilter.h"

@interface HouseTableViewController : UITableViewController

@property (nonatomic) HOUSER_CONTROLLER_TYPE controllerType;
@property (nonatomic) HouseFilter *filter;
@property (nonatomic, weak) id container;

@end
