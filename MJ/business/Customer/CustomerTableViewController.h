//
//  CustomerTableViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerFilter.h"

typedef NS_ENUM(NSInteger, CUSTOMER_CONTROLLER_TYPE)
{
    CCT_RENT    = 1,
    CCT_SELL     = 2,
};

@interface CustomerTableViewController : UITableViewController

@property (nonatomic) CUSTOMER_CONTROLLER_TYPE controllerType;
@property (nonatomic) CustomerFilter *filter;
@property (nonatomic, weak) id container;
- (void)refreshData;

@end
