//
//  WebViewController.m
//  MJ
//
//  Created by harry on 15/5/21.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "WebViewController.h"

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
    [_webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


@end
