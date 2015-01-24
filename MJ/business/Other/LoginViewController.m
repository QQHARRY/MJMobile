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
#import "person.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idTxt.text = @"XA-";
    [self readDefaultMsg];
    // Do any additional setup after loading the view.
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.idTxt resignFirstResponder];
    [self.pwdTxt resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self initConstraint];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.autoLogin && [self.idTxt.text length] > 0 && [self.pwdTxt.text length] > 0)
    {
        [self loginBtnClicked:nil];
    }
    
}
-(void)initConstraint
{
//    self.idTxt.translatesAutoresizingMaskIntoConstraints = NO;

    //[self.view constraints];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idTxt attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImg attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
//    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //[segue  ]
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)readDefaultMsg
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL autoLogin =[prefs boolForKey:@"AutoLogin"];
    self.autoLoginSwitchBtn.on = autoLogin;
    if (autoLogin)
    {
        NSString*defaultUsrName =[prefs stringForKey:@"defaultUsrName"];
        NSString*defaultPwd =[prefs stringForKey:@"defaultPwd"];
        
        self.idTxt.text = defaultUsrName;
        self.pwdTxt.text = defaultPwd;
    }
}

-(void)writeDefaultMsg
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL autoLogin  = self.autoLoginSwitchBtn.on;
    NSString*usrName = @"";
    NSString*pwd = @"";
    if (autoLogin)
    {
        usrName = self.idTxt.text;
        pwd = self.pwdTxt.text;
    }
    
    
    [prefs setBool:autoLogin forKey:@"AutoLogin"];
    [prefs setValue:usrName forKey:@"defaultUsrName"];
    [prefs setValue:pwd forKey:@"defaultPwd"];
    [prefs synchronize];

}


- (IBAction)loginBtnClicked:(id)sender {

    NSString* strID = self.idTxt.text;
    
    NSString* strPwd = self.pwdTxt.text;
    if ([strID length] <= 0 || [strPwd length] <= 0)
    {
        PRESENTALERT(@"输入错误",@"用户名和密码不能为空",@"OK",self);
        return;
    }
    
    
    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd,@"DeviceID" : [UtilFun getUDID],@"DeviceType" : DEVICE_IOS};
    [NetWorkManager PostWithApiName:API_LOGIN parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString*Status = [resultDic objectForKey:@"Status"];
         
         
         if (Status == nil || [Status  length] <= 0)
         {
             PRESENTALERT(SERVER_NONCOMPLIANCE,SERVER_NONCOMPLIANCE_INFO,@"OK",self);
             return;
         }
         else
         {
             NSInteger iStatus = [Status intValue];
             switch (iStatus)
             {
                 case 0:
                 {
                     
                     NSArray*arrTmp =[resultDic objectForKey:@"userinfo"];
                     
                     [[person initMe:[arrTmp objectAtIndex:0]] setPassword:strPwd];
                     
                     [self writeDefaultMsg];
                     [self performSegueWithIdentifier:@"LoginToMainPage" sender:self];
                     AppDelegate*app = [[UIApplication sharedApplication] delegate];
                     [app setMemberID:[person me].job_no];
                     return;
                 }
                     break;
                 case 1:
                 {
                     PRESENTALERT(@"登录失败",@"用户名或密码错误,请重新输入",@"OK",self);
                     return;
                 }
                     break;
                 case 2:
                 {
                     PRESENTALERT(@"登录失败",@"尚未审批通过，请耐心等待",@"OK",self);
                     return;
                 }
                     break;
                 case 3:
                 {
                     PRESENTALERT(@"登录失败",@"此设备尚未绑定该账号，请先绑定再登陆",@"OK",self);
                     return;
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

         PRESENTALERT(SERVER_NONCOMPLIANCE,errorStr,@"OK",self);
         
     }];
    
    SHOWHUD(self.view);
}

- (IBAction)applyForBindingBtnClicked:(id)sender {
    AppDelegate*app = [[UIApplication sharedApplication] delegate];
    [app loadBindStory];
}
@end
