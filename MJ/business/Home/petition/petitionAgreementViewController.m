//
//  petitionAgreementViewController.m
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionAgreementViewController.h"

@interface petitionAgreementViewController ()

@end

@implementation petitionAgreementViewController
@synthesize opinionForAgreement;
@synthesize petition;
@synthesize historyNodeTableView;
@synthesize opinionLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConstraint];
    
    
    self.historyNodeTableView.delegate = self;
    self.historyNodeTableView.dataSource = self;
    
    
    opinionForAgreement.layer.cornerRadius=1;
    opinionForAgreement.layer.masksToBounds=YES;
    opinionForAgreement.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    opinionForAgreement.layer.borderWidth= 1.0f;
}


-(void)initConstraint
{
    self.historyNodeTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.opinionForAgreement.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.historyNodeTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.45 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.historyNodeTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.opinionForAgreement attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0]];
    
   [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.opinionForAgreement attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 2;
}





- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"历史节点";
    }
    else if(section == 1)
    {
        return @"当前部门";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.petition && self.petition.historyNodes)
        {
            return petition.historyNodes.count;
        }
    }
    else if(section == 1)
    {
        return 1;
    }
    
        

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString*key = @"tableview";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    
    cell.textLabel.text = @"sdfdsfsdfsdfsdf";
    return nil;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)agreeBtnClicked:(id)sender {
}

- (IBAction)disAgreeBtnClicked:(id)sender {
}
@end
