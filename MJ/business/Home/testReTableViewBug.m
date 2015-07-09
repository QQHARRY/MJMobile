//
//  testReTableViewBug.m
//  MJ
//
//  Created by harry on 15/7/9.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "testReTableViewBug.h"
#import "RETableViewManager.h"



@interface testReTableViewBug()
@property(nonatomic,strong)RETableViewManager*manager;
@property(nonatomic,strong)RETableViewSection*section;

@end

@implementation testReTableViewBug




-(void)viewDidLoad
{
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.section = [[RETableViewSection alloc] initWithHeaderTitle:@"房源信息"];
    [self.manager addSection:self.section];
    for (int i =0; i < 50; i++) {
        
        RETextItem*item = [[RETextItem alloc]  initWithTitle:[NSString stringWithFormat:@"%d",i]];
        [self.section addItem:item];
    }
}

@end
