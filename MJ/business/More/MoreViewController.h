//
//  MoreViewController.h
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckNewVersion.h"

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,updateDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
