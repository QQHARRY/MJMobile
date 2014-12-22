//
//  RegisterViewController.h
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *logoImg;
@property (strong, nonatomic) IBOutlet UITextField *idTxt;
@property (strong, nonatomic) IBOutlet UITextField *pwdTxt;
@property (strong, nonatomic) IBOutlet UISwitch *autoLoginSwitchBtn;
- (IBAction)loginBtnClicked:(id)sender;
- (IBAction)applyForBindingBtnClicked:(id)sender;

@end
