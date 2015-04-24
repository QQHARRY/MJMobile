//
//  ContactPsnListViewController.h
//  MJ
//
//  Created by harry on 15/4/22.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unit.h"


@interface ContactPsnListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableview;


@property(strong,nonatomic)unit*superUnt;
@property(strong,nonatomic)NSMutableArray*listContent;

@property(strong,nonatomic)unit*selectedUnt;


- (IBAction)onSearch:(id)sender;

@end
