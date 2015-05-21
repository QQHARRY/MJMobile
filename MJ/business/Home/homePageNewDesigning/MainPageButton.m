//
//  MainPageButton.m
//  MJ
//
//  Created by harry on 15/5/21.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#define BUTTONHEIGHT 24
#define XSPACE 6.5



#import "MainPageButton.h"
#import "UIButton+Badge.h"



@interface MainPageButton()

@property(strong,nonatomic)UIImageView*logo;


@end



@implementation MainPageButton


- (instancetype)initWithOrig:(CGPoint)point
{
    CGRect tmpFrame = CGRectMake(point.x, point.y, BTN_CONTENT_WIDTH, BTN_CONTENT_HEIGHT);
    
    
    if (self = [super initWithFrame:tmpFrame])
    {
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.masksToBounds = YES;
        
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(XSPACE, (CGRectGetHeight(self.frame)-BUTTONHEIGHT)/2.0, BUTTONHEIGHT, BUTTONHEIGHT)];
        [self addSubview:_logo];
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        _btn.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        //_btn.backgroundColor = [UIColor clearColor];
        _btn.layer.borderWidth = 0.5;
        _btn.layer.borderColor = [UIColor whiteColor].CGColor;
        _btn.layer.masksToBounds = YES;
        
        _btn.badgeMinSize = 6;
        _btn.badgeBGColor = [UIColor redColor];
        _btn.badgeTextColor = [UIColor whiteColor];
        _btn.shouldAnimateBadge = YES;
        _btn.shouldHideBadgeAtZero = YES;
        
        [self addSubview:_btn];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor Logo:(UIImage*)logoImage Title:(NSString*)titleStr Badge:(NSInteger)badgeNum
{
    self.backgroundColor = backgroundColor;

    [self.btn setTitle:titleStr forState:UIControlStateNormal];
    if (badgeNum == 0)
    {
        self.btn.badgeValue = nil;
    }
    else
    {
        self.btn.badgeValue = [NSString stringWithFormat:@"%d",(int)badgeNum];
    }
    
    self.logo.image = logoImage;
    
    
  
    
    _btn.badgeOriginX = CGRectGetWidth(_btn.frame)-21;
    _btn.badgeOriginY =2;
    
}

-(void)setBadge:(NSInteger)badgeNum
{
    if (badgeNum == 0)
    {
        self.btn.badgeValue = nil;
    }
    else
    {
        self.btn.badgeValue = [NSString stringWithFormat:@"%d",(int)badgeNum];
    }

    _btn.badgeOriginX = CGRectGetWidth(_btn.frame)-21;
    _btn.badgeOriginY =2;
}


@end
