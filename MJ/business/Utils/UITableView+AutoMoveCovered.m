//
//  UITableView+AutoMoveCovered.m
//  MJ
//
//  Created by harry on 15/4/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//
#import "UITableView+AutoMoveCovered.h"


@interface UITableView()



@end

CGRect ViewOriginFrame;

@implementation UITableView(UITableView_AutoMoveCovered)


- (void) scrollViewIfControlCoveredByKeyboard:(UIView *)control atIndexPath:(NSIndexPath *)indexPath  hasStatusBar:(BOOL)hasStatusBar hasNavigationBar:(BOOL)hasNavBar KeyBoardHeight:(NSInteger)kbHeight
{
    
    CGFloat keyboardHeight = kbHeight;
    CGFloat navBarHeight = 44.0f;
    CGFloat statusBarHeight = 20.0f;
    CGFloat screenHeight =  [UIScreen mainScreen].bounds.size.height;
    
    ViewOriginFrame = self.frame;
    CGFloat controlYRelativeToScreen = (((CGRect)[self rectForRowAtIndexPath:indexPath]).origin.y + control.frame.origin.y) + self.frame.origin.y + control.frame.size.height;
    
//    NSLog(@"Cell Y %f",((CGRect)[self rectForRowAtIndexPath:indexPath]).origin.y);
//    NSLog(@"Self Y %f",control.frame.origin.y);
//    NSLog(@"Tbl  Y %f",self.frame.origin.y);
//    NSLog(@"Self H %f",control.frame.size.height);
//    NSLog(@"All  H %f",controlYRelativeToScreen);
    
    if (hasStatusBar)
    {
        controlYRelativeToScreen += statusBarHeight;
    }
    if (hasNavBar)
    {
        controlYRelativeToScreen += navBarHeight;
    }
    CGFloat invisiblePixels = keyboardHeight - (screenHeight - controlYRelativeToScreen) - self.bounds.origin.y;
    if (invisiblePixels > 0)
    {
        [UIView beginAnimations:@"scrollView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.275f];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - invisiblePixels, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
    }
}
- (void) restoreViewPosition
{
    
    [UIView beginAnimations:@"restoreViewPosition" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.200f];
    self.frame = ViewOriginFrame;
    [UIView commitAnimations];
}

@end
