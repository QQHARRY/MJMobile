//
//  WebViewController.m
//  MJ
//
//  Created by harry on 15/5/21.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "WebViewController.h"
#import "person.h"

@interface WebViewController ()

@property(strong,nonatomic)UIWebView*webV;


@end

@implementation WebViewController

@synthesize url;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _webV = [[UIWebView alloc ]initWithFrame:self.view.frame];
    _webV.scalesPageToFit = YES;
    [self.view addSubview:_webV];
    
}

-(void)viewWillAppear:(BOOL)animated
{
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
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    
    [request setHTTPBody: [array dataUsingEncoding: NSUTF8StringEncoding]];
    
    [_webV loadRequest:request];
}


@end
