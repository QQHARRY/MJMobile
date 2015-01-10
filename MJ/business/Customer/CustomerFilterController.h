//
//  CustomerFilterController.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "CustomerViewController.h"

@interface CustomerFilterController : UITableViewController
    <RETableViewManagerDelegate>

@property (nonatomic, weak) CustomerViewController *hvc;

@end
