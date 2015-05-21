//
//  MainpageLabeView.h
//  MJ
//
//  Created by harry on 15/5/20.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#define SCREEN_WIDTH      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define SCREEN_HEIGHT      CGRectGetHeight([UIScreen mainScreen].applicationFrame)

//为了保证在不同设备上，界面布局的比例和设计图一致,在这里按照设计图的比例，来计算部件的尺寸

#define YSPACE 4
#define LABEL_HEIGHT (((60+YSPACE)/548.0)*SCREEN_HEIGHT)
#define LABEL_WIDTH (SCREEN_WIDTH/3.0)
#define CONTENT_WIDTH LABEL_WIDTH
#define CONTENT_HEIGHT ((60/548.0)*SCREEN_HEIGHT)


#import <UIKit/UIKit.h>

@interface MainPageLabeView : UIView
@property(strong,nonatomic)UIImageView*logo;
@property(strong,nonatomic)UILabel*title;
@property(strong,nonatomic)UILabel*content;

- (instancetype)initWithOrig:(CGPoint)point;
-(void)setLogo:(UIImage*)logoImage Title:(NSString*)titleStr Content:(NSString*)contentStr;
-(void)setContentText:(NSString*)contentStr;
@end
