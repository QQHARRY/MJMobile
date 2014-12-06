//
//  RegisterViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "LoginViewController.h"
#import "UtilFun.h"
#import "Macro.h"
#import "NetWorkManager.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(void)viewWillAppear:(BOOL)animated
{
    //[self initConstraint];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self initConstraint];
    
    if (![UtilFun hasFirstBinded])
    {
        [self performSegueWithIdentifier:@"toBindView" sender:self];
    }
}
-(void)initConstraint
{
    self.idTxt.translatesAutoresizingMaskIntoConstraints = NO;

    //[self.view constraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
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

- (IBAction)loginBtnClicked:(id)sender {
   // NSString* strID = self.idTxt.text;
    NSString* strID = @"XA-1200166";
    
    //NSString* strPwd = self.pwdTxt.text;
    NSString* strPwd = @"1";
    if ([strID length] <= 0 || [strPwd length] <= 0)
    {
        [UtilFun presentPopViewControllerWithTitle:@"输入错误" Message:@"请输入正确的用户名和密码" SimpleAction:@"OK" Sender:self];
        return;
    }
    
    
    //NSDictionary *parameters = @{@"job_no":@"XA-1200166", @"acc_password": @"1",@"DeviceID" : @"justfortest",@"DeviceType" : @"0"};
    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd,@"DeviceID" : @"justfortest",@"DeviceType" : DEVICE_IOS};
    [NetWorkManager PostWithApiName:API_LOGIN parameters:parameters success:
     ^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString*Status = [resultDic objectForKey:@"Status"];
         
         
         if (Status == nil || [Status  length] <= 0)
         {
             [UtilFun presentPopViewControllerWithTitle:@"服务器错误" Message:@"服务器接口未返回状态" SimpleAction:@"OK" Sender:self];
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
         
     }];
}
@end
