//
//  HouseFilterController.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HouseViewController.h"

@interface HouseFilterController : UITableViewController
    <RETableViewManagerDelegate>

@property (nonatomic, weak) HouseViewController *hvc;

@end
