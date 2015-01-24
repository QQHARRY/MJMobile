//
//  CustomerListFilterController.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "CustomerViewController.h"
#import "ContactListTableViewController.h"

@interface CustomerListFilterController : UITableViewController
    <RETableViewManagerDelegate, contacSelection>

//@property (nonatomic, weak) CustomerViewController *hvc;

-(void)returnSelection:(NSArray*)curSelection;

@end
