//
//  ViewController.m
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "BindViewController.h"
#import "Macro.h"
#import "NetWorkManager.h"

@interface BindViewController ()

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idTxtFld attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(IBAction)onBindAction:(id)sender
{

    NSDictionary *parameters = @{@"job_no":@"XA-1200166", @"acc_password": @"1",@"DeviceID" : @"justfortest",@"DeviceType" : @"0"};

    [NetWorkManager PostWithApiName:API_REG parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

     }
          failure:^(NSError *error)
     {
  
     }];
    
    

}

@end
