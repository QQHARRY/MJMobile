//
//  houseClientRemarkDetailsViewController.m
//  MJ
//
//  Created by harry on 15/5/6.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "houseDescribeViewController.h"

@interface houseDescribeViewController ()


@property(strong,nonatomic)UIWebView*webV;
@end

@implementation houseDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-44)];
    self.webV.scalesPageToFit = YES;
    [self.view addSubview:self.webV];
    
    [self.webV loadHTMLString:self.client_remark baseURL:nil];
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
