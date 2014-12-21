//
//  RestPassWordViewController.m
//  MJ
//
//  Created by harry on 14/12/21.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "RestPassWordViewController.h"
#import "UtilFun.h"
#import "person.h"
#import "NetWorkManager.h"
#import "Macro.h"

@interface RestPassWordViewController ()

@end

@implementation RestPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)commitBtnClicked:(id)sender
{
    NSString*oPwd = [self.oldPwd text];
    NSString*newPwd1 = self.pwd1.text;
    NSString*newPwd2 = self.pwd2.text;
    if (oPwd.length == 0 || newPwd1.length == 0 || newPwd2.length == 0)
    {
        [UtilFun presentPopViewControllerWithTitle:@"信息填写不全" Message:@"请填写完成" SimpleAction:@"OK" Sender:self];
        return;
    }
    else if([newPwd1 isEqualToString:newPwd2] == NO)
    {
        [UtilFun presentPopViewControllerWithTitle:@"新密码两次输入不一致" Message:@"请填重新填写" SimpleAction:@"OK" Sender:self];
        return;
    }
    
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password": [person me].password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"oldPassword" : oPwd,
                                 @"newPassword" : newPwd1,

                                 };
    [NetWorkManager PostWithApiName:EDIT_PIN_NO parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
          [UtilFun presentPopViewControllerWithTitle:@"修改成功" Message:@"" SimpleAction:@"OK" Sender:self];
         
     }
                            failure:^(NSError *error)
     {
         HIDEHUD(self.view);
         [UtilFun presentPopViewControllerWithTitle:@"修改失败" Message:@"" SimpleAction:@"OK" Sender:self];
         
     }];
    
   
}
@end
