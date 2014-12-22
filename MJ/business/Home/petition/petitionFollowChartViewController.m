//
//  petitionFollowChartViewController.m
//  MJ
//
//  Created by harry on 14/12/18.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "petitionFollowChartViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UtilFun.h"

@interface petitionFollowChartViewController ()

@end

@implementation petitionFollowChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   

    [self.webView setScalesPageToFit:YES];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}


-(void)viewDidAppear:(BOOL)animated
{

    
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
