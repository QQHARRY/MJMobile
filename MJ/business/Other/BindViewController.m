//
//  ViewController.m
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "BindViewController.h"
#import "Macro.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "AppDelegate.h"

@interface BindViewController ()

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.idTxtFld.delegate = self;
    self.idTxtFld.text = @"XA-";
    //[self initConstraint];
    
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  // return NO to not change text
//{
//    
//    NSMutableString*oldStr = [[NSMutableString alloc] initWithString:textField.text];
//    
//    NSLog(@"old=%@",oldStr);
//    NSLog(@"string=%@",string);
//    NSLog(@"location=%ld,length=%ld",range.location,range.length);
//    
//    return YES;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.idTxtFld resignFirstResponder];
    [self.pwdTxtFld resignFirstResponder];
}

-(void)initConstraint
{
    self.idTxtFld.translatesAutoresizingMaskIntoConstraints = NO;
    self.pwdTxtFld.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoImg.translatesAutoresizingMaskIntoConstraints = NO;
    self.bindBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.guideLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel1.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel2.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel3.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idTxtFld attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pwdTxtFld attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(IBAction)onBindAction:(id)sender
{

    NSString* strID = self.idTxtFld.text;

    
    NSString* strPwd = self.pwdTxtFld.text;

    if ([strID length] <= 0 || [strPwd length] <= 0)
    {
        PRSENTALERT(@"输入错误",@"请输入正确的用户名和密码",@"OK",self);
        return;
    }
    

    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd,@"DeviceID" : [UtilFun getUDID],@"DeviceType" : DEVICE_IOS};
    [NetWorkManager PostWithApiName:API_REG parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString*Status = [resultDic objectForKey:@"Status"];

        
         if (Status == nil || [Status  length] <= 0)
         {
             PRSENTALERT(SERVER_NONCOMPLIANCE,SERVER_NONCOMPLIANCE_INFO,@"OK",self);
         }
         else
         {
             NSInteger iStatus = [Status intValue];
             switch (iStatus)
             {
                 case 0:
                 {
                     [UtilFun setFirstBinded];
      
                     PRSENTALERTWITHHANDER(@"绑定成功",@"请等待审核通过或联系管理员",@"OK",self,^(UIAlertAction *action)
                     {
                         [self toLoginPage];
                     }
                                           );
                     
                     
                     return;
                 }
                     break;
                 case 1:
                 {
                     PRSENTALERT(@"绑定失败",@"用户名或密码错误,请重新输入",@"OK",self);
                     return;
                 }
                     break;
                 case 2:
                 {
                     
                     [UtilFun setFirstBinded];

                     PRSENTALERTWITHHANDER(@"绑定成功",@"管理员已审核通过,可登陆进入系统",@"OK",self,^(UIAlertAction *action)
                                           {
                                               [self toLoginPage];
                                           }
                                           );
                 }
                     break;
                 default:
                     break;
             }
         }
        
     }
          failure:^(NSError *error)
     {
         HIDEHUD(self.view);
         NSString*errorStr = [NSString stringWithFormat:@"%@",error];
         
         PRSENTALERT(SERVER_NONCOMPLIANCE,errorStr,@"OK",self);
         
     }];
    
    SHOWHUD(self.view);

}

-(void)toLoginPage
{
    AppDelegate*app = [[UIApplication sharedApplication] delegate];
    [app loadMainSotry:NO];
}

- (IBAction)onLoginAction:(id)sender
{
    [self toLoginPage];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"绑定成功"] && buttonIndex == 0)
    {
        [self toLoginPage];
    }
}

@end
