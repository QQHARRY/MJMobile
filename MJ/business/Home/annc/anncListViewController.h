//
//  anncListViewController.h
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnncListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableArray*mainAnncArr;

@end
