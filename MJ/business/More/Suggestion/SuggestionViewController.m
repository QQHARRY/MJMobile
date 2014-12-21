//
//  SuggestionViewController.m
//  MJ
//
//  Created by harry on 14/12/20.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "SuggestionViewController.h"
#import "UtilFun.h"
#import "person.h"
#import "Macro.h"
#import "NetWorkManager.h"

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    CALayer*layer = self.content.layer;
    layer.cornerRadius=8;
    layer.masksToBounds=YES;
    layer.borderColor=[[UIColor lightGrayColor]CGColor];
    layer.borderWidth= 0.5;
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

- (IBAction)annoymousChanged:(id)sender {
    
}
- (IBAction)sendBtnClicked:(id)sender {
    NSString*strTitle = self.sugesstionTitle.text;
    NSString*strContent = self.sugesstionTitle.text;

    if (strTitle.length == 0 || strContent.length == 0)
    {
         [UtilFun presentPopViewControllerWithTitle:@"美嘉十分需要您的宝贵意见" Message:@"请填写完整的信息" SimpleAction:@"OK" Sender:self];
        return;
    }
    
    NSString*strContactMethod = self.sugesstionTitle.text;
    BOOL isAnnoymous = self.annoymous.on;
    
    SHOWHUD(self.view);
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSDictionary *parameters = @{@"job_no":[person me].job_no,
                                 @"acc_password": [person me].password,
                                 @"DeviceID" : [UtilFun getUDID],
                                 @"DeviceType" : DEVICE_IOS,
                                 @"VersionName" : version,
                                 @"Title" : strTitle,
                                 @"Content" : strContent,
                                 @"Anonymous":[NSNumber numberWithBool:isAnnoymous],
                                 @"ContactEmail":strContactMethod
                                 };
    [NetWorkManager PostWithApiName:SUGGESTION_FEEDBACK parameters:parameters success:
     ^(id responseObject)
     {
         HIDEHUD(self.view);
         [UtilFun presentPopViewControllerWithTitle:@"十分感谢您的宝贵意见" Message:@"我们会尽快安排工作人员着手处理相关问题" SimpleAction:@"OK" Sender:self];
         [self.navigationController popViewControllerAnimated:YES];
     }
                            failure:^(NSError *error)
     {
         HIDEHUD(self.view);
         [UtilFun presentPopViewControllerWithTitle:@"发送失败" Message:@"请重新发送" SimpleAction:@"OK" Sender:self];


     }];
    
   
    
}
@end
