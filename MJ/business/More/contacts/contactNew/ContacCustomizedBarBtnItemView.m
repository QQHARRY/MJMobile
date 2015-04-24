//
//  ContacCustomizedBarBtnItemView.m
//  MJ
//
//  Created by harry on 15/4/23.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContacCustomizedBarBtnItemView.h"


#define IMAGESIZE 16
#define TITLELENGTH 20

@implementation ContacCustomizedBarBtnItemView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(rect), CGRectGetMidY(rect), IMAGESIZE, IMAGESIZE)];
    self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.image.frame) + 2, CGRectGetMidY(rect), CGRectGetMaxX(rect)-(CGRectGetMaxX(self.image.frame) + 2),30 )];
    [self addSubview:self.image];
    [self addSubview:self.titlelabel];
    
    
    [self.titlelabel setTextColor:[UIColor blueColor]];
}



@end
