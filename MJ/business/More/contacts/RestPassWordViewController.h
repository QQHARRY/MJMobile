//
//  RestPassWordViewController.h
//  MJ
//
//  Created by harry on 14/12/21.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestPassWordViewController : UIViewController
- (IBAction)commitBtnClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *oldPwd;
@property (strong, nonatomic) IBOutlet UITextField *pwd1;
@property (strong, nonatomic) IBOutlet UITextField *pwd2;


@end
