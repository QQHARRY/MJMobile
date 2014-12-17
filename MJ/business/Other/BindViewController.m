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

@interface BindViewController ()

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self initConstraint];
    
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
    //NSString* strID = @"XA-1200166";
    
    NSString* strPwd = self.pwdTxtFld.text;
    //NSString* strPwd = @"1";
    if ([strID length] <= 0 || [strPwd length] <= 0)
    {
        [UtilFun presentPopViewControllerWithTitle:@"输入错误" Message:@"请输入正确的用户名和密码" SimpleAction:@"OK" Sender:self];
        return;
    }
    
    
    //NSDictionary *parameters = @{@"job_no":@"XA-1200166", @"acc_password": @"1",@"DeviceID" : @"justfortest",@"DeviceType" : @"0"};
    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd,@"DeviceID" : [UtilFun getUDID],@"DeviceType" : DEVICE_IOS};
    [NetWorkManager PostWithApiName:API_REG parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString*Status = [resultDic objectForKey:@"Status"];

        
         if (Status == nil || [Status  length] <= 0)
         {
              [UtilFun presentPopViewControllerWithTitle:SERVER_NONCOMPLIANCE Message:SERVER_NONCOMPLIANCE_INFO SimpleAction:@"OK" Sender:self];
         }
         else
         {
             NSInteger iStatus = [Status intValue];
             switch (iStatus)
             {
                 case 0:
                 {
                     [UtilFun setFirstBinded];
                     [UtilFun presentPopViewControllerWithTitle:@"绑定成功" Message:@"请等待审核通过或联系管理员" SimpleAction:@"OK"  Handler:^(UIAlertAction *action)
                      {
                          [self performSegueWithIdentifier:@"bindOk" sender:self];
                      }
                      Sender:self];
                     
                     return;
                 }
                     break;
                 case 1:
                 {
                     [UtilFun presentPopViewControllerWithTitle:@"绑定失败" Message:@"用户名或密码错误,请重新输入" SimpleAction:@"OK" Sender:self];
                     return;
                 }
                     break;
                 case 2:
                 {
                     
                     [UtilFun setFirstBinded];
                     [UtilFun presentPopViewControllerWithTitle:@"绑定成功" Message:@"管理员已审核通过,可登陆进入系统" SimpleAction:@"OK"  Handler:^(UIAlertAction *action)
                      {
                          [self performSegueWithIdentifier:@"bindOk" sender:self];
                      }
                                                         Sender:self];

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
         [UtilFun presentPopViewControllerWithTitle:SERVER_NONCOMPLIANCE Message:errorStr SimpleAction:@"OK" Sender:self];
         
     }];
    
    SHOWHUD(self.view);

}

- (IBAction)onLoginAction:(id)sender
{
    [self performSegueWithIdentifier:@"bindOk" sender:self];
}

@end
