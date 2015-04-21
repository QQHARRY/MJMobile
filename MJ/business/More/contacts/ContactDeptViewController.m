//
//  ContactDeptViewController.m
//  MJ
//
//  Created by harry on 15/4/20.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactDeptViewController.h"
#import "ContactsListTableViewCell.h"


@interface ContactDeptViewController ()

@end

@implementation ContactDeptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    UIImageView*imagV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"放大镜icon-ios"]];
    
    self.searchTextField.leftViewMode = UITextFieldViewModeUnlessEditing;
    self.searchTextField.leftView = imagV;
    
    self.searchTextField.layer.cornerRadius = 10.0f;
    
    self.searchTextField.layer.borderColor = [UIColor colorWithRed:0xa7/225.0 green:0xab/225.0 blue:0xc6/225.0 alpha:1].CGColor;
    self.searchTextField.layer.borderWidth= 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [[UITableViewCell alloc] init];
    cell.textLabel.text  = @"111111";
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSearch:(id)sender {
    
    
    
}
@end
