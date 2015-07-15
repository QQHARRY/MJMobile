//
//  testViewPagerController.m
//  MJ
//
//  Created by harry on 15/7/15.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "testViewPagerController.h"
#import "testPageViewTVC.h"

@interface testViewPagerController()

@property(nonatomic,strong)testPageViewTVC*v1;
@property(nonatomic,strong)testPageViewTVC*v2;

@end

@implementation testViewPagerController


-(void)viewDidLoad{
    
    self.dataSource = self;
    self.delegate = self;
    [super viewDidLoad];
    

}

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
    if (_v1 == nil)
    {
        _v1 = [[testPageViewTVC alloc] init];
    }
    if (_v2 == nil)
    {
        _v2 = [[testPageViewTVC alloc] init];
    }
    if (index ==0 )
    {
        return _v1;
    }
    
    return _v2;

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
