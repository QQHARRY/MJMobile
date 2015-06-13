//
//  houseDoubleFieldCell.m
//  MJ
//
//  Created by harry on 15/6/11.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "houseDoubleFieldCell.h"

#define SPACE_L_S 12
#define SPACE_T_V 5
#define FONTSIZE 14
#define LABEL_H 22
#define MAX_TITLE_W 75
#define MIN_TITLE_W 20
#define TITLE_COLOR [UIColor lightGrayColor]

@interface houseDoubleFieldCell()

@property(strong,nonatomic)UILabel*field1Title;
@property(strong,nonatomic)UILabel*field1Value;
@property(strong,nonatomic)UILabel*field2Title;
@property(strong,nonatomic)UILabel*field2Value;


@property(strong,nonatomic)NSString*strTitle1;
@property(strong,nonatomic)NSString*strValue1;
@property(strong,nonatomic)NSString*strTitle2;
@property(strong,nonatomic)NSString*strValue2;
@end

@implementation houseDoubleFieldCell


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _field1Title = [[UILabel alloc] init];
        _field1Value = [[UILabel alloc] init];
        _field2Title = [[UILabel alloc] init];
        _field2Value = [[UILabel alloc] init];
        
        [_field1Title setFont:[UIFont systemFontOfSize:FONTSIZE]];
        [_field2Title setFont:[UIFont systemFontOfSize:FONTSIZE]];
        [_field1Value setFont:[UIFont systemFontOfSize:FONTSIZE]];
        [_field2Value setFont:[UIFont systemFontOfSize:FONTSIZE]];
        
        [_field1Title setTextColor:TITLE_COLOR];
        [_field2Title setTextColor:TITLE_COLOR];
        
        [self.contentView addSubview:_field1Title];
        [self.contentView addSubview:_field1Value];
        [self.contentView addSubview:_field2Title];
        [self.contentView addSubview:_field2Value];
        
    }
    
    return self;
}


-(void)setT1:(NSString*)t1 V1:(NSString*)v1 T2:(NSString*)t2 V2:(NSString*)v2
{
    _strTitle1 = t1;
    _strTitle2 = t2;
    _strValue1 = v1;
    _strValue2 = v2;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    NSInteger valueCnt = (_strTitle1 != nil  && _strTitle2 != nil)?2:1 ;
    
    _field2Title.hidden = valueCnt < 2;
    _field2Value.hidden = valueCnt < 2;
    
    _field1Title.text = _strTitle1;
    _field1Value.text = _strValue1;
    _field2Title.text = _strTitle2;
    _field2Value.text = _strValue2;
    
    CGRect rct = self.frame;
    
    CGFloat y = CGRectGetHeight(self.frame)/2.0f - LABEL_H/2.0f;
    
    CGFloat t1W = [self widthOfLabel:_field1Title];
    _field1Title.frame = CGRectMake(SPACE_L_S, y, t1W, LABEL_H);
    
    CGFloat v1X = CGRectGetMaxX(_field1Title.frame) + SPACE_T_V;
    CGFloat v1W = CGRectGetWidth(self.frame)/(valueCnt) - v1X - SPACE_T_V;
    _field1Value.frame = CGRectMake(v1X, y, v1W, LABEL_H);
    
    if (valueCnt > 1)
    {
        
        CGFloat t2X = CGRectGetMaxX(_field1Value.frame) + SPACE_T_V;
        CGFloat t2W = [self widthOfLabel:_field2Title];
        _field2Title.frame = CGRectMake(t2X,y,t2W,LABEL_H);
        
        
        CGFloat v2X = CGRectGetMaxX(_field2Title.frame) + SPACE_T_V;
        CGFloat v2W = CGRectGetMaxX(self.frame) - CGRectGetMaxX(_field2Title.frame) - 2*SPACE_T_V;
        _field2Value.frame = CGRectMake(v2X, y, v2W, LABEL_H);
        
    }
    
    
    
}


-(CGFloat)widthOfLabel:(UILabel*)label
{
    CGSize sz  = [self calculateString:label.text SizeWithFont:label.font];
    if (sz.width < MIN_TITLE_W)
    {
        return MIN_TITLE_W;
    }
    else if(sz.width > MAX_TITLE_W)
    {
        return MAX_TITLE_W;
    }
    
    return sz.width;
}

- (CGSize)calculateString:(NSString*)str SizeWithFont:(UIFont *)font
{
    if (str == nil || font == nil)
    {
        return CGSizeMake(0, 0);
    }
    NSDictionary *dic = @{NSFontAttributeName: font};
    CGSize size = [str boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}






- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
