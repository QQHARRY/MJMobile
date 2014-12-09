//
//  MainPageViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MainPageViewController.h"
#import "UIViewController+FastNavgationBarItem.h"
#import "NetWorkManager.h"
#import "Macro.h"
#import "UtilFun.h"
#import "person.h"


@interface MainPageViewController ()

@end

@implementation MainPageViewController
@synthesize unReadAlertCnt;
@synthesize unReadMessageCount;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    
    // Do any additional setup after loading the view.
    
    
    [self setupLeftMenuButtonOfVC:self Image:[UIImage imageNamed:@"logo.png"] action:@selector(leftBtnSelected:)];
    [self setupRightMenuButtonOfVC:self Image:[UIImage imageNamed:@"logo.png"] action:@selector(leftBtnSelected:)];
    
    [self initTable];
}



-(void)getAnncCount
{
    NSString* strID = [person me].job_no;
    NSString* strPwd = [person me].password;
    
    NSDictionary *parameters = @{@"job_no":strID , @"acc_password": strPwd};
    
    
    [NetWorkManager PostWithApiName:API_ALERT_COUNT parameters:parameters success:
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
             if (iStatus == 0)
             {
                 
             }
             else
             {
                 [UtilFun presentPopViewControllerWithTitle:@"服务器错误" Message:@"获取未读公告数量错误" SimpleAction:@"OK"  Handler:nil
                                                     Sender:self];
             }
             
         }
         
     }
                            failure:^(NSError *error)
     {
         NSString*errorStr = [NSString stringWithFormat:@"%@",error];
         [UtilFun presentPopViewControllerWithTitle:@"绑定失败" Message:errorStr SimpleAction:@"OK" Sender:self];
         
     }];
}

-(void)loadData
{
    
}
-(void)initTable
{

    self.tableView = [[UITableView alloc ] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

-(IBAction)leftBtnSelected:(id)sender
{
    
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

@end
