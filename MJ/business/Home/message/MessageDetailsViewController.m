//
//  MessageDetailsViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MessageDetailsViewController.h"
#import "sendMessageViewController.h"
#import "UtilFun.h"
#import "messageManager.h"
#import "Macro.h"

@interface MessageDetailsViewController ()

@end

@implementation MessageDetailsViewController
@synthesize msg;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGRect selfFrame = self.view.frame;

    self.contentWebView.layer.cornerRadius=3;
    self.contentWebView.layer.masksToBounds=YES;
    self.contentWebView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.contentWebView.layer.borderWidth= 1.0f;
    
    //[self.contentWebView setScalesPageToFit:YES];
    if (msg)
    {
//        cell.receiver.text = obj.msg_opt_user_list_name;
//        cell.msgSender.text = obj.view_user_list_name;
//        cell.briefContent.text = obj.msg_title;
//        cell.sendTime.text = obj.msg_save_date;
        self.msgSender.text = msg.view_user_list_name;
        self.sendTime.text = msg.msg_save_date;
        self.reveiverList.text = msg.msg_opt_user_list_name;
        self.ccList.text = msg.msg_cc_user_list_name;
        self.msgTitle.text = msg.msg_title;

        [self.contentWebView loadHTMLString:msg.msg_content baseURL:nil];
        
        
        if ([msg.unread_flag isEqualToString:@"0"])
        {
            [self setMsgReaded:msg];
        }
        
    }
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setMsgReaded:(messageObj*)msgObj
{
    if (msgObj)
    {
        SHOWHUD(self.view);
        [messageManager setMessage:msgObj ReadStatus:MJMESSAGETYPE_UNREAD Success:^(id responseObject) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINPAGE_INDICATOR_NUMBER_CHANGED object:nil];
            HIDEHUD(self.view);
        } failure:^(NSError *error) {
            HIDEHUD(self.view);
        }];
        
    }
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

- (IBAction)replyAll:(id)sender {
    sendMessageViewController*ctrl = [[sendMessageViewController alloc] initWithNibName:@"sendMessageViewController" bundle:[NSBundle mainBundle]];
    ctrl.msgObj = self.msg;
    ctrl.msgType = MJMESSAGESENDTYPE_REPLY_ALL;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (IBAction)singleReply:(id)sender
{
    sendMessageViewController*ctrl = [[sendMessageViewController alloc] initWithNibName:@"sendMessageViewController" bundle:[NSBundle mainBundle]];
    ctrl.msgObj = self.msg;
    ctrl.msgType = MJMESSAGESENDTYPE_REPLY_SINGLE;
    [self.navigationController pushViewController:ctrl animated:YES];
}
@end
