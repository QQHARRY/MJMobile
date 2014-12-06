//
//  RegisterViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "LoginViewController.h"
#import "UtilFun.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self initConstraint];
}
-(void)viewDidAppear:(BOOL)animated
{
    //[self initConstraint];
    
    if (![UtilFun hasFirstBinded])
    {
        [self performSegueWithIdentifier:@"toBindView" sender:self];
    }
}
-(void)initConstraint
{
    self.idTxt.translatesAutoresizingMaskIntoConstraints = NO;

    //[self.view constraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginBtnClicked:(id)sender {
    
}
@end
