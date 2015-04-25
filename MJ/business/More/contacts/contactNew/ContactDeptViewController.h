//
//  ContactDeptViewController.h
//  MJ
//
//  Created by harry on 15/4/20.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unit.h"

@interface ContactDeptViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)onSearch:(id)sender;


@property (strong,nonatomic)unit*superUnit;
@property (strong,nonatomic)unit*selected;
@property (assign,nonatomic)BOOL isSearchMode;
@property (strong,nonatomic)NSMutableArray*untArr;



@end
