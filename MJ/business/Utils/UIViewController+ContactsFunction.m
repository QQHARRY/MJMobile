//
//  UIViewController+_ContactsFunction.m
//  MJ
//
//  Created by harry on 15/5/7.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIViewController+ContactsFunction.h"
#import "ChatViewController.h"

#import "EaseMob.h"
#import "UtilFun.h"

@implementation UIViewController (ContactsFunction)


-(void)ct_onImMessage:(person*)psn
{
    NSArray*arr = [self.navigationController viewControllers];
    
    for (UIViewController*vc in arr)
    {
        if ([vc isKindOfClass:[ChatViewController class]])
        {
            if ([((ChatViewController*)vc).chatter isEqualToString:psn.job_no.lowercaseString])
            {
                [self.navigationController  popToViewController:vc animated:YES];
                return;
            }
            
        }
    }
    
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[psn.job_no lowercaseString] isGroup:NO];
    chatVC.title = psn.name_full;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)ct_onAddFriend:(person*)psn
{
    if ([[person me] isImOpened])
    {
        
        [self showHudInView:self.view hint:NSLocalizedString(@"friend.sendApply", @"sending application...")];
        person*psnMe = [person me];
        NSString*message = [[NSString alloc] initWithFormat:@"%@ %@:%@ 申请添加您为好友",psnMe.company_name, psnMe.department_name,psnMe.name_full];
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:[psn.job_no lowercaseString] message:message error:&error];
        [self hideHud];
        if (error)
        {
            PRESENTALERT(@"",NSLocalizedString(@"friend.sendApplyFail", @"send application fails, please operate again"), nil,nil, nil);
        }
        else
        {
            PRESENTALERT(@"", NSLocalizedString(@"friend.sendApplySuccess", @"send successfully"), nil,nil, nil);
            
        }
        
    }
    else
    {
        PRESENTALERT(@"添加好友失败", @"您尚未开通IM,请先联系管理员开通", nil, nil,nil);
    }
    
}

-(void)ct_onCall:(person*)psn
{
    UIWebView*callWebview =[[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",psn.obj_mobile]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

-(void)ct_onCallWithPhoneNumber:(NSString*)phoneNum
{
    UIWebView*callWebview =[[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

-(void)ct_onShortMessage:(person*)psn
{
    
    UIWebView*callWebview =[[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",psn.obj_mobile]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}




@end
