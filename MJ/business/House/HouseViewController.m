//
//  HouseViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseViewController.h"
#import "NetWorkManager.h"
#import "UtilFun.h"
#import "Macro.h"
#import "person.h"
#import "HouseTableViewController.h"
#import "HouseFilter.h"

@interface HouseViewController ()

@property (nonatomic) HOUSER_CONTROLLER_TYPE nowControllerType;
@property (nonatomic, strong) HouseTableViewController *rentController;
@property (nonatomic, strong) HouseTableViewController *sellController;

@end

@implementation HouseViewController

- (void)viewDidLoad
{
    // init controller base info
    self.title = @"房源";
    self.dataSource = self;
    self.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // default is sell controller
    self.nowControllerType = HCT_SELL;
    
    // ios version fixed code
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif

    // add title button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterAction:)];
    
    // add table view controller
    self.rentController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.rentController.controllerType = HCT_RENT;
    self.rentController.container = self;
    self.rentController.filter = [[HouseFilter alloc] init];
    self.rentController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.rentController.filter.trade_type = @"101";
    self.rentController.filter.sale_trade_state = @"0";
    self.rentController.filter.lease_trade_state = @"0";
    self.rentController.filter.FromID = @"0";
    self.rentController.filter.ToID = @"0";
    self.rentController.filter.Count = @"10";
    self.sellController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.sellController.controllerType = HCT_SELL;
    self.sellController.container = self;
    self.sellController.filter = [[HouseFilter alloc] init];
    self.sellController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.sellController.filter.trade_type = @"100";
    self.sellController.filter.sale_trade_state = @"0";
    self.sellController.filter.lease_trade_state = @"0";
    self.sellController.filter.FromID = @"0";
    self.sellController.filter.ToID = @"0";
    self.sellController.filter.Count = @"10";

    // super fun
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFilterAction:(id)sender
{
    // todo
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    CGSize sz =  [UIScreen mainScreen].bounds.size;
    UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sz.width/2.0, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:14]];
    if (index == 0)
    {
        // default is sell controller
        label.text = @"出售";
    }
    else
    {
        label.text = @"出租";
    }
    return  label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        return self.sellController;
    }
    else
    {
        return self.rentController;
    }
    return nil;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case ViewPagerOptionStartFromSecondTab:
            return 0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0;
            break;
        case ViewPagerOptionTabLocation:
            return 1;
            break;
        case ViewPagerOptionTabWidth:
            return [UIScreen mainScreen].bounds.size.width / 2.0;
            break;
        default:
            break;
    }
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component)
    {
        case ViewPagerIndicator:
            return [UIColor redColor];
            break;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
            break;
        case ViewPagerContent:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    return color;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    if (index == 0)
    {
        self.nowControllerType = HCT_SELL;
    }
    else
    {
        self.nowControllerType = HCT_RENT;
    }
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


//-(void)sendMessage:(id)sender
//{
//    sendMessageViewController*ctrl = [[sendMessageViewController alloc] initWithNibName:@"sendMessageViewController" bundle:[NSBundle mainBundle]];
//    ctrl.msgObj = nil;
//    ctrl.msgType = MJMESSAGESENDTYPE_SEND;
//    [self.navigationController pushViewController:ctrl animated:YES];
//}


// test api
//    NSString* strID = [person me].job_no;
//    NSString* strPwd = [person me].password;
//    NSDictionary *parameters = @{@"job_no" : strID,
//                                 @"acc_password" : strPwd,
//                                 @"DeviceID" : [UtilFun getUDID],
//                                 @"FromID" : @"0",
//                                 @"ToID" : @"0",
//                                 @"Count" : @"10", // 单页返回的 录条数，最大不超过100， 认为10
//                                 @"trade_type" : @"", // 房源类型:比如出售 是”100”，出租 是”101” （此参数在默认房源列表查询时必须有，字典表里有）
//                                 @"sale_trade_state" : @"0", // 状态（出售）                                 （此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）                                 无效	6                                 锁盘	99                                 有效	0                                 我售	2                                 已售	3
//                                 @"lease_trade_state" : DEVICE_IOS, // 状态（出租）                                 （此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）                                 锁盘	99                                 我租	2                                 已租	3                                 无效	6                                 有效	0
//                                 @"consignment_type" : @"1", // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2”
//                                 @"hall_num" : @"2", // 房屋类型的厅的数量:如2厅
//                                 @"room_num" : @"3", // 房屋类型的室的数量:如3室
//                                 @"buildname" : @"", // 栋座，比如1号楼
//                                 @"house_unit" : @"", // 单元，比如2单元
//                                 @"house_floor" : @"", // 楼层
//                                 @"house_tablet" : @"", // 房号
//                                 @"house_driect" : @"", // 朝向
//                                 @"structure_area_from" : @"", // 最小面积
//                                 @"structure_area_to" : @"", // 最大面积
//                                 @"housearea" : @"", // 区域:比如城内
//                                 @"houseurban" : @"", // 片区:比如钟楼
//                                 @"fitment_type" : @"", // 装修类型:比如精装
//                                 @"house_floor_from" : @"", // 指定最小楼层
//                                 @"house_floor_to" : @"", // 指定最大楼层
//                                 @"sale_value_from" : @"", // 最低价格,单位万
//                                 @"sale_value_to" : @"", // 最高价格,单位万
//                                 @"lease_value_from" : @"",  // 最低价格,单位元/月
//                                 @"lease_value_to" : @"", // 最高价格,单位元/月
//                                 @"Keyword" : @"", // 搜索关键字
//                                 };
//    [NetWorkManager PostWithApiName:API_HOUSE_LIST parameters:parameters success:
//     ^(id responseObject)
//     {
//         HIDEHUD(self.view);
//         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSString*Status = [resultDic objectForKey:@"Status"];


//         if (Status == nil || [Status  length] <= 0)
//         {
//             [UtilFun presentPopViewControllerWithTitle:SERVER_NONCOMPLIANCE Message:SERVER_NONCOMPLIANCE_INFO SimpleAction:@"OK" Sender:self];
//         }
//         else
//         {
//             NSInteger iStatus = [Status intValue];
//             switch (iStatus)
//             {
//                 case 0:
//                 {
//                     [UtilFun setFirstBinded];
//                     [UtilFun presentPopViewControllerWithTitle:@"绑定成功" Message:@"请等待审核通过或联系管理员" SimpleAction:@"OK"  Handler:^(UIAlertAction *action)
//                      {
//                          [self performSegueWithIdentifier:@"bindOk" sender:self];
//                      }
//                                                         Sender:self];
//
//                     return;
//                 }
//                     break;
//                 case 1:
//                 {
//                     [UtilFun presentPopViewControllerWithTitle:@"绑定失败" Message:@"用户名或密码错误,请重新输入" SimpleAction:@"OK" Sender:self];
//                     return;
//                 }
//                     break;
//                 case 2:
//                 {
//
//                     [UtilFun setFirstBinded];
//                     [UtilFun presentPopViewControllerWithTitle:@"绑定成功" Message:@"管理员已审核通过,可登陆进入系统" SimpleAction:@"OK"  Handler:^(UIAlertAction *action)
//                      {
//                          [self performSegueWithIdentifier:@"bindOk" sender:self];
//                      }
//                                                         Sender:self];
//
//                 }
//                     break;
//                 default:
//                     break;
//             }
//         }
//     }
//                            failure:^(NSError *error)
//     {
//         HIDEHUD(self.view);
//         NSString*errorStr = [NSString stringWithFormat:@"%@",error];
//         [UtilFun presentPopViewControllerWithTitle:SERVER_NONCOMPLIANCE Message:errorStr SimpleAction:@"OK" Sender:self];
//
//     }];
//
//    SHOWHUD(self.view);
