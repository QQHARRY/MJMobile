//
//  MainPageViewController.h
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactListTableViewController.h"
#import "CheckNewVersion.h"

@interface MainPageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,contacSelection,updateDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property(strong,nonatomic)NSArray*mainAnncArr;
@property(strong,nonatomic)NSArray*mainPetitionArr;


@end
