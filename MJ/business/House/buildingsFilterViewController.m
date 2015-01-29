//
//  buildingsFilterViewController.m
//  MJ
//
//  Created by harry on 15/1/17.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "buildingsFilterViewController.h"

@interface buildingsFilterViewController ()
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *searchContitions;
@property (strong, readwrite, nonatomic) RETextItem *buildingsName;
@property (strong, readwrite, nonatomic) RETableViewItem *searchItem;
@end

@implementation buildingsFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.searchContitions = [self addNameSearchControls];
}

- (RETableViewSection *)addNameSearchControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"查询条件"];
    [self.manager addSection:section];
    self.buildingsName = [RETextItem itemWithTitle:@"楼盘名称" value:nil placeholder:@"请输入楼盘名称"];
    [section addItem:self.buildingsName];
    
    
    self.searchItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                         {
                             if (self.queryCondition == nil)
                             {
                                 self.queryCondition = [[NSMutableDictionary alloc] init];
                             }
                             
                             [self.queryCondition removeAllObjects];
                             
                             [self.queryCondition setValue:self.buildingsName.value forKey:@"buildings_name"];
                             self.buildingsSel.needRefresh = YES;
                             [self.navigationController popViewControllerAnimated:YES];
                             
                         }];
    [section addItem:self.searchItem];
    return section;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
