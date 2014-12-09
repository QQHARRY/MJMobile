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
#import "unReadManager.h"
#import "badgeImageFactory.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    
    // Do any additional setup after loading the view.
    
    //UIImage*imageLeft = []
    
    [self setupLeftMenuButtonOfVC:self Image:[UIImage imageNamed:@"logo.png"] action:@selector(leftBtnSelected:)];
    [self setupRightMenuButtonOfVC:self Image:[UIImage imageNamed:@"logo.png"] action:@selector(leftBtnSelected:)];
    
    [self initTable];
    
    [self loadData];
}


-(void)setUpNavigationBarItem
{
    
}


-(void)getUnReadAlertCnt
{
    SHOWHUD(self.view);
   [unReadManager getUnReadAlertCntSuccess:^(id responseObject) {
       HIDEHUD(self.view);
       
   } failure:^(NSError *error) {
       HIDEHUD(self.view);
   }];
}


-(void)getUnReadMsgCnt
{
    SHOWHUD(self.view);
    [unReadManager getUnReadMessageCntSuccess:^(id responseObject) {
        HIDEHUD(self.view);
        
    } failure:^(NSError *error) {
        HIDEHUD(self.view);
    }];
}

-(void)loadData
{
    [self getUnReadAlertCnt];
    [self getUnReadMsgCnt];
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
