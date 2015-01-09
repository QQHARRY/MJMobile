//
//  PersonDetailsViewController.h
//  MJ
//
//  Created by harry on 14/12/20.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "person.h"

@interface PersonDetailsViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *myName;

@property (strong, nonatomic) IBOutlet UILabel *company;
@property (strong, nonatomic) IBOutlet UILabel *department;
@property (strong, nonatomic) IBOutlet UILabel *character;
@property (strong, nonatomic) IBOutlet UILabel *lastLoginIP;
@property (strong, nonatomic) IBOutlet UILabel *lastLoginTime;
@property (strong, nonatomic) IBOutlet UIButton *myPhoto;
@property (strong, nonatomic) IBOutlet UITextField *loginName;
@property (strong, nonatomic) IBOutlet UITextField *mobileNum;
@property (strong, nonatomic) IBOutlet UITextField *chracterSign;
@property (strong, nonatomic) IBOutlet UITextField *personalInfo;

@property (assign, nonatomic)BOOL photoChanged;

@property (strong, nonatomic)person*psn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *smsBtn;
- (IBAction)phoneBtnClicked:(id)sender;
- (IBAction)smsBtnClicked:(id)sender;

- (IBAction)clickPhotoBtn:(id)sender;
- (IBAction)clickSaveButton:(id)sender;


@end
