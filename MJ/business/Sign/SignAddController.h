//
//  SignAddController.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HouseViewController.h"
#import "CustomerListFilterController.h"

@interface SignAddController : UITableViewController
    <RETableViewManagerDelegate>

@property (nonatomic, strong) NSString *sid;

@end
