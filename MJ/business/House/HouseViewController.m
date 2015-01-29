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
#import "HouseFilter.h"
#import "HouseFilterController.h"
#import "HouseAddNewViewController.h"

@interface HouseViewController ()

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddEstate:)];
    
    // add table view controller
    self.rentController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.rentController.controllerType = HCT_RENT;
    self.rentController.container = self;
    self.rentController.filter = [[HouseFilter alloc] init];
//    self.rentController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.rentController.filter.trade_type = @"101";
//    self.rentController.filter.sale_trade_state = @"0";
    self.rentController.filter.lease_trade_state = @"0";
    self.rentController.filter.FromID = @"0";
    self.rentController.filter.ToID = @"0";
    self.rentController.filter.Count = @"10";
    self.sellController = [[HouseTableViewController alloc] initWithNibName:@"HouseTableViewController" bundle:[NSBundle mainBundle]];
    self.sellController.controllerType = HCT_SELL;
    self.sellController.container = self;
    self.sellController.filter = [[HouseFilter alloc] init];
//    self.sellController.filter.consignment_type = @"1"; // 委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” * TODO
    self.sellController.filter.trade_type = @"100";
    self.sellController.filter.sale_trade_state = @"0";
//    self.sellController.filter.lease_trade_state = @"0";
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
    HouseFilterController *vc = [[HouseFilterController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.hvc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onAddEstate:(id)sender
{
    HouseAddNewViewController*vc = [[HouseAddNewViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
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

