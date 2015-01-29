//
//  CantactListUnitTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#define kLevelOffset    10

#import "ContactListUnitTableViewCell.h"
#import "department.h"
#import "person.h"

@implementation ContactListUnitTableViewCell
@synthesize unitName;
@synthesize expandBtn;

- (void)awakeFromNib {
    // Initialization code
    
    CGRect rect = unitName.frame;
    rect.origin.x =0;
    unitName.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)expandBtnClicked:(id)sender {
    if (self.action)
    {
        [self.delegate performSelector:self.action withObject:self.expandBtn];
    }
}

-(void)setUnit:(unit*)unt withTag:(long)tag delegate:(id)dele action:(SEL)action;
{
    
    NSArray*arr = [self subviews];
    for (UIView* subView in arr)
    {
        if ([subView isKindOfClass:[UIButton class]] || [subView isKindOfClass:[UILabel class]])
        {
            [subView removeFromSuperview];
        }
    }
    _level = unt.level;
    self.delegate = dele;
    self.action = action;
    
    
    expandBtn =[[UIButton alloc] initWithFrame:CGRectMake(5+kLevelOffset*_level, 4.5, 20, 20)];
    unitName = [[UILabel alloc] initWithFrame:CGRectMake(25+kLevelOffset*_level,4.5, 200, 21)];
    [expandBtn addTarget:self action:@selector(expandBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:expandBtn];
    [self addSubview:unitName];
    
    
    
    [unitName setFont:[UIFont systemFontOfSize:12]];
    if ([unt  isKindOfClass:[department class]])
    {
        unitName.text = ((department*)unt).dept_name;
    }
    else if([unt  isKindOfClass:[person class]])
    {
        unitName.text = ((person*)unt).name_full;
    }
    
    expandBtn.tag = tag;
    
    if (!unt.isDept)
    {
        expandBtn.hidden = YES;
        //[self.contentView setBackgroundColor:[UIColor darkGrayColor]];
        
    }
    else
    {
        expandBtn.hidden = NO;
        //[self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (unt.closed)
    {
        [self.expandBtn setBackgroundImage:[UIImage imageNamed:@"ButtonPlus"] forState:UIControlStateNormal];
    }
    else
    {
        [self.expandBtn setBackgroundImage:[UIImage imageNamed:@"ButtonMinus"] forState:UIControlStateNormal];
    }

}

@end
