//
//  ViewController.h
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>


- (IBAction)onBindAction:(id)sender;
- (IBAction)onLoginAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *logoImg;
@property (strong, nonatomic) IBOutlet UITextField *idTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *pwdTxtFld;
@property (strong, nonatomic) IBOutlet UIButton *bindBtn;
@property (strong, nonatomic) IBOutlet UILabel *guideLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel1;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel2;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel3;

@end

