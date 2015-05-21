//
//  MainPageButton.h
//  MJ
//
//  Created by harry on 15/5/21.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SCREEN_WIDTH      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define SCREEN_HEIGHT      CGRectGetHeight([UIScreen mainScreen].applicationFrame)

//为了保证在不同设备上，界面布局的比例和设计图一致,在这里按照设计图的比例，来计算部件的尺寸
#define BTN_CONTENT_WIDTH (SCREEN_WIDTH/3.0)
#define BTN_CONTENT_HEIGHT ((46/548.0)*SCREEN_HEIGHT)

@interface MainPageButton : UIView

@property(strong,nonatomic)UIButton*btn;
- (instancetype)initWithOrig:(CGPoint)point;
-(void)setBackgroundColor:(UIColor *)backgroundColor Logo:(UIImage*)logoImage Title:(NSString*)titleStr Badge:(NSInteger)badgeNum;

-(void)setBadge:(NSInteger)badgeNum;

@end
