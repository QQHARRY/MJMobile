//
//  AnncDetailsViewController.m
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AnncDetailsViewController.h"

@interface AnncDetailsViewController ()

@end

@implementation AnncDetailsViewController
@synthesize annc;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (self.annc)
    {
        self.publickTimeAndBy.text = [NSString stringWithFormat:@"发布时间:%@ 发布人:%@",self.annc.issue_date,self.annc.issue_person_name];
        [self.webView loadHTMLString:self.annc.notice_content baseURL:nil];

    }
}
-(void)initConstrains
{
//    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    //[self.webView setScalesPageToFit:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self initConstrains];
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

@end
