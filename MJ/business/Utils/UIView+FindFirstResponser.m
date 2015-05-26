//
//  UIView+FindFirstResponser.m
//  MJ
//
//  Created by harry on 15/5/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIView+FindFirstResponser.h"

@implementation UIView (FindFirstResponser)

-(UIView*) findFirstResponder
{
    
    if (self.isFirstResponder) return self;
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) return firstResponder;
    }
    return nil;
    
}

-(void)hideKeyboard
{
    UIView*firstRes = [self findFirstResponder];
    if (firstRes)
    {
        [firstRes resignFirstResponder];
    }
}

@end
