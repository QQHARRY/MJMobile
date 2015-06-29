//
//  UIViewController+addGaussianBlurView.h
//  MJ
//
//  Created by harry on 15/6/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^CompletionBlk)();

@interface UIViewController (addGaussianBlurView)


-(void)addBlurViewWithCompletion:(CompletionBlk)complete;
-(void)removeBlurView;
@end
