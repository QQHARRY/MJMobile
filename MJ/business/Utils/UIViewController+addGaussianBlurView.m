//
//  UIViewController+addGaussianBlurView.m
//  MJ
//
//  Created by harry on 15/6/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIViewController+addGaussianBlurView.h"
#import "HouseParticularTableViewController.h"
#import <UIKit/UIGraphics.h>


@interface UIViewController()
{
    //
}

//@property (nonatomic, copy)CompletionBlk completion;
@property (nonatomic, strong)UIVisualEffectView* effectview;
@end

@implementation UIViewController (addGaussianBlurView)




-(void)addBlurViewWithCompletion:(CompletionBlk)complete
{
    if (self.effectview == nil)
    {
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        self.effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//        self.effectview.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height+20);
////        UIGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedOnBluringView:)];
////        [self.effectview addGestureRecognizer:tap];
        
       
        
    }
    
    
    
    //self.completion = complete;
    
    
    
    if (self.navigationController)
    {
        [self.navigationController.view addSubview:self.effectview];
    }
    else
    {
        [self.view addSubview:self.effectview];
    }
}
-(void)removeBlurView
{
    if (self.effectview)
    {
        [self.effectview removeFromSuperview];
    }
}

-(void)tapedOnBluringView:(id)sender
{
    [self removeBlurView];
//    CompletionBlk blk = self.completion;
//    if (blk)
//    {
//        blk();
//    }
}

@end
