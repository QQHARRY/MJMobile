//
//  CustomerParticularTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetail.h"
#import "CustomerParticulars.h"
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"


@interface CustomerParticularTableViewController : UITableViewController
    <RETableViewManagerDelegate>

@property (strong, nonatomic) CustomerDetail *detail;
@property (strong, nonatomic) CustomerParticulars *particulars;

@end
