//
//  petitionAgreementViewController.m
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionAgreementViewController.h"
#import "petitionHistoryNodeTableViewCell.h"

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
    
    opinionForAgreement.layer.cornerRadius=1;
    opinionForAgreement.layer.masksToBounds=YES;
    opinionForAgreement.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    opinionForAgreement.layer.borderWidth= 1.0f;
    
    [self initConstraint];
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
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return @"历史节点";
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
    
        

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString*key = @"petitionHistoryNodeTableViewCell";
    petitionHistoryNodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
    if (cell == nil)
    {
        cell = [[petitionHistoryNodeTableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
    }
    
    cell.textRecord.text = @"sdfdsfsdfsdfsdf";
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
