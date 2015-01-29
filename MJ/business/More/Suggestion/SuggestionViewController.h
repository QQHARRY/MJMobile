//
//  SuggestionViewController.h
//  MJ
//
//  Created by harry on 14/12/20.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *sugesstionTitle;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UISwitch *annoymous;
- (IBAction)annoymousChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *concactMethod;
- (IBAction)sendBtnClicked:(id)sender;

@end
