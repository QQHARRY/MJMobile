//
//  ContactListTableViewController.h
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unit.h"

@interface ContactListTableViewController : UITableViewController

@property(nonatomic,strong)unit*contactListTreeHead;

- (IBAction)expandBtnClicked:(id)sender;

@end
