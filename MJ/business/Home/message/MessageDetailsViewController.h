//
//  MessageDetailsViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageObj.h"

@interface MessageDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *msgSender;
@property (strong, nonatomic) IBOutlet UILabel *sendTime;
@property (strong, nonatomic) IBOutlet UITextField *reveiverList;
@property (strong, nonatomic) IBOutlet UITextField *ccList;
@property (strong, nonatomic) IBOutlet UITextField *msgTitle;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;

@property (strong, nonatomic) messageObj*msg;

- (IBAction)replyAll:(id)sender;

- (IBAction)singleReply:(id)sender;

@end
