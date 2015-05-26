//
//  MainpageLabeView.m
//  MJ
//
//  Created by harry on 15/5/20.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#define LOGOX 6.5
#define LOGOY 5.5
#define LOGORADIUS 12
#define TITLE_LABEL_HEIGHT 17

#define TITLE_FONT_SZ 13
#define CONTENT_FONT_SZ 15

#define SPACE_FROM_LOGO_2_TITLE 2
#define LINEH 1

#define TITLECOLOR [UIColor colorWithRed:0x52/255.0 green:0x52/255.0 blue:0x52/255.0 alpha:1]
#define BGCOLOR [UIColor colorWithRed:0xf4/255.0 green:0xf4/255.0 blue:0xf8/255.0 alpha:1]
#define BORDERCOLOR [UIColor colorWithRed:0xd1/255.0 green:0xd1/255.0 blue:0xd1/255.0 alpha:1].CGColor
#define LINECOLOR [UIColor colorWithRed:0xda/255.0 green:0xda/255.0 blue:0xde/255.0 alpha:1]



#import "MainPageLabeView.h"

@interface MainPageLabeView()


@property(strong,nonatomic)UIView*contentView;

@end

@implementation MainPageLabeView
@synthesize logo;
@synthesize title;
@synthesize content;

- (instancetype)initWithOrig:(CGPoint)point
{

    CGRect tmpFrame = CGRectMake(point.x, point.y, LABEL_WIDTH, LABEL_HEIGHT);
    

    if (self = [super initWithFrame:tmpFrame])
    {
        
        tmpFrame = CGRectMake(0, LABEL_HEIGHT-CONTENT_HEIGHT, CONTENT_WIDTH, CONTENT_HEIGHT);
        
        self.contentView = [[UIView alloc] initWithFrame:tmpFrame];
        self.contentView.backgroundColor = BGCOLOR;
        self.contentView.layer.borderColor = BORDERCOLOR;
        self.contentView.layer.borderWidth = 0.5;
        [self addSubview:self.contentView];
        
            
        
        CGFloat width = CGRectGetWidth(tmpFrame);
        CGFloat height = CGRectGetHeight(tmpFrame);
        //CGFloat midX = width/2.0;
        CGFloat midY = CGRectGetHeight(tmpFrame)/2.0;
        
        
        logo = [[UIImageView alloc] initWithFrame:CGRectMake(LOGOX, midY-2*LOGORADIUS, LOGORADIUS*2, LOGORADIUS*2)];
        logo.layer.cornerRadius = LOGORADIUS;
        logo.layer.masksToBounds = YES;
        [self.contentView addSubview:logo];
        
        
        
        CGFloat titleW = (width - 2*CGRectGetMinX(logo.frame))-CGRectGetWidth(logo.frame) - SPACE_FROM_LOGO_2_TITLE;
        title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logo.frame)+SPACE_FROM_LOGO_2_TITLE, CGRectGetMidY(logo.frame)-TITLE_LABEL_HEIGHT/2.0, titleW, TITLE_LABEL_HEIGHT)];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:TITLE_FONT_SZ];
        title.textColor = TITLECOLOR;
        [self.contentView addSubview:title];
        
        UILabel*labelLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logo.frame)+SPACE_FROM_LOGO_2_TITLE, midY-LINEH/2.0, titleW, LINEH)];
        labelLine.backgroundColor = LINECOLOR;
        [self.contentView addSubview:labelLine];
    
        
        content = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, height*3/4.0-TITLE_LABEL_HEIGHT/2.0, title.frame.size.width, TITLE_LABEL_HEIGHT)];
        content.font = [UIFont boldSystemFontOfSize:CONTENT_FONT_SZ];
        content.textColor = TITLECOLOR;
        content.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:content];
        
    }
    return self;
}

-(void)setLogo:(UIImage*)logoImage Title:(NSString*)titleStr Content:(NSString*)contentStr
{
    self.logo.image = logoImage;
    self.title.text = titleStr;
    if (contentStr && [contentStr intValue] == 0)
    {
        self.content.text = nil;
    }
    else
    {
        self.content.text = contentStr;
    }
    
    
}

-(void)setContentText:(NSString*)contentStr
{
    CGSize sz = [self calculateTitleSizeWithString:contentStr];
    if (sz.width > self.content.frame.size.width)
    {
        self.content.frame = CGRectMake(0, self.content.frame.origin.y, self.frame.size.width, self.content.frame.size.height);
        self.content.font = [UIFont systemFontOfSize:TITLE_FONT_SZ];
    }
    
    
    if (contentStr && [contentStr intValue] == 0)
    {
        self.content.text = @"0";
    }
    else
    {
        self.content.text = contentStr;
    }
}



- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = TITLE_LABEL_HEIGHT;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

@end
