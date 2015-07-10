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
    for (int i = 1; i < 50; i++) {
        RETableViewItem*item = nil;
        switch (i%4)
        {
            case 0:
            {
                item = [[RETextItem alloc]  initWithTitle:[NSString stringWithFormat:@"Text%d",i]];
                [self.section addItem:item];
            }
                break;
            case 1:
            {
                item = [[RERadioItem alloc]  initWithTitle:[NSString stringWithFormat:@"Radio%d",i]];
                [self.section addItem:item];
            }
                break;
            case 2:
            {
                item = [[ReMultiTextItem alloc]  initWithTitle:[NSString stringWithFormat:@"MultiText%d",i]];
                [self.section addItem:item];
            }
                break;
            case 3:
            {
                item = [[RENumberItem alloc]  initWithTitle:[NSString stringWithFormat:@"Number%d",i]];
                [self.section addItem:item];
            }
                break;
                
            default:
                break;
        }
        if (i%5 == 0)
        {
            item.enabled = NO;
        }
    }
}

@end
