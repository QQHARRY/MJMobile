//
//  ContactDeptViewController.h
//  MJ
//
//  Created by harry on 15/4/20.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unit.h"

@interface ContactDeptViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)onSearch:(id)sender;


@property (strong,nonatomic)unit*superUnit;


@end
