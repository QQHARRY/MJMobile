//
//  MessagePageViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MessagePageViewController.h"
#import "MessageTableViewController.h"
#import "sendMessageViewController.h"

@interface MessagePageViewController ()
{
    NSMutableArray* catagoryVCArr;
}
@end

@implementation MessagePageViewController

- (void)viewDidLoad {
        // Do any additional setup after loading the view.
    self.title = @"站内信";
    self.dataSource = self;
    self.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   // self.navigationController.navigationBar.hidden = YES;
    catagoryVCArr = [[NSMutableArray alloc] init];
    MessageTableViewController*readPage = [[MessageTableViewController alloc ] initWithNibName:@"MessageTableViewController" bundle:[NSBundle mainBundle]];
    readPage.msgType = MJMESSAGETYPE_READED;
    readPage.container = self;
    MessageTableViewController*unReadPage = [[MessageTableViewController alloc ] initWithNibName:@"MessageTableViewController" bundle:[NSBundle mainBundle]];
    unReadPage.msgType = MJMESSAGETYPE_UNREAD;
    unReadPage.container = self;
    [catagoryVCArr addObject:unReadPage];
    [catagoryVCArr addObject:readPage];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发信" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage:)];
    
    [super viewDidLoad];

}

-(void)sendMessage:(id)sender
{
    sendMessageViewController*ctrl = [[sendMessageViewController alloc] initWithNibName:@"sendMessageViewController" bundle:[NSBundle mainBundle]];
    ctrl.msgObj = nil;
    ctrl.msgType = MJMESSAGESENDTYPE_SEND;
    [self.navigationController pushViewController:ctrl animated:YES];
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

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    CGSize sz =  [UIScreen mainScreen].bounds.size;
    UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sz.width/2.0, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:14]];
    if (index == 0)
    {
         label.text = @"未读";
    }
    else
    {
         label.text = @"已读";
    }

    
    return  label;
    
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    
    
    UIViewController* vc = [catagoryVCArr objectAtIndex:index];
    return vc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
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
            return [UIScreen mainScreen].bounds.size.width/2.0;
            break;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor redColor];
            break;
        case ViewPagerTabsView:
        {
            return [UIColor whiteColor];
            
            break;
        }
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
    
}

@end
