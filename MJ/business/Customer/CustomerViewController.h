//
//  CustomerViewController.h
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "CustomerTableViewController.h"


@interface CustomerViewController : ViewPagerController
    <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic) CUSTOMER_CONTROLLER_TYPE nowControllerType;
@property (nonatomic, strong) CustomerTableViewController *rentController;
@property (nonatomic, strong) CustomerTableViewController *sellController;
@property (nonatomic, assign)BOOL applyForRefresh;
@end

