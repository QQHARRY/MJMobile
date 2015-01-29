//
//  AnncDetailsViewController.h
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "announcement.h"

@interface AnncDetailsViewController : UIViewController

@property(strong,nonatomic)announcement*annc;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *publickTimeAndBy;



@end
