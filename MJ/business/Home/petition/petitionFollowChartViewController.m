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
#import "person.h"

@interface petitionFollowChartViewController ()

@end

@implementation petitionFollowChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self.webView setScalesPageToFit:YES];
    
    NSMutableDictionary*param = [[NSMutableDictionary alloc] init];
    [param setObject:[person me].job_no forKey:@"job_no"];
    [param setObject:[person me].password forKey:@"acc_password"];
    
    NSString *array = @"";
    int i=0;
    for(NSString *key in param)
    {
        if(i>0)
        {
            array = [array stringByAppendingString:@"&"];
        }
        
        array = [array stringByAppendingString:[NSString stringWithFormat:@"%@=%@", key, [param objectForKey:key]]];
        i++;
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.url]];
    [request setHTTPMethod: @"POST"];
    
    [request setHTTPBody: [array dataUsingEncoding: NSUTF8StringEncoding]];
    
    [self.webView loadRequest:request];
    
    
    
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
