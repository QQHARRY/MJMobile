//
//  ViewController.m
//  MJ
//
//  Created by harry on 14-11-22.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "BindViewController.h"
#import "Macro.h"
#import "AFNetworking.h"

@interface BindViewController ()

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.idTxtFld attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.85 constant:0]];
    // Do any additional setup after loading the view, typically from a nib.
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
    // WARNING:
    // Just For Test
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置afgrom的响应解析器
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    // 设置响应解析器的接受类型
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置请求参数
    NSDictionary *parameters = @{@"job_no":@"XA-1200166", @"acc_password": @"1",@"DeviceID" : @"justfortest",@"DeviceType" : @"0"};
    //    NSDictionary *parameters = @{@"username": @"1234567@qq.com", @"password": @"5d793fc5b00a2348c3fb9ab59e5ca98a", @"device" : @"iPhone5s-iOS7-China"};
    // 显示loading hud
//    SHOWHUD;
    // post提交请求
    [manager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, API_REG] parameters:parameters success:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         // 这里是请求成功的block
//         // 隐藏hud
//         HIDEHUD;
//         // 使用xmlreader解析响应返回值
//         NSError *error = nil;
//         NSDictionary *dict = [XMLReader dictionaryForXMLData:responseObject error:&error];
//         // Alur Begin
//         
//         if ([[[dict objectForKey:@"Result"] objectForKey:@"success"]boolValue]) {
//             // 设置登录成功
//             GUM.bLogin = true;
//             UIAlertView *alertTemp = [[UIAlertView alloc] initWithTitle:@"当前账号已成功登出"
//                                                                 message:nil
//                                                                delegate:nil
//                                                       cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//             [alertTemp show];
//             [self.navigationController popViewControllerAnimated:YES];
//         }else{
//             // 设置登录失败  提示登录失败信息
//             GUM.bLogin = false;
//             RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"O K" action:^
//                                         {
//                                         }];
//             UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"登出当前账号失败"
//                                                          message:[[dict objectForKey:@"Result"] objectForKey:@"msg"]
//                                                 cancelButtonItem:cancelItem
//                                                 otherButtonItems:nil];
//             [av show];
//             
//         }  // Alur End
//         
         NSLog(@"JSON: %@%@", operation, responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         // 这里是请求失败的block
//         HIDEHUD;
         NSLog(@"Error: %@%@", operation, error);
//         // 使用UIAlertView提示用户
//         // TODO, 没有将字符串本地化
//         RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"O K" action:^
//                                     {
//                                     }];
//         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"请求失败"
//                                                      message:@"可能是网络问题, 请稍后再试!"
//                                             cancelButtonItem:cancelItem
//                                             otherButtonItems:nil];
//         [av show];
     }];
    
    

}

@end
