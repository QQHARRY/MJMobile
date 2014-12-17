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



-(void)setUnit:(unit*)unt withTag:(long)tag action:(SEL)action
{
    _level = unt.level;
    
    CGRect rect = unitName.frame;
    rect.origin.x =50 + kLevelOffset * _level;
    unitName.frame = rect;
    
    rect = expandBtn.frame;
    rect.origin.x =10 + kLevelOffset * _level;
    expandBtn.frame = rect;
    
    [unitName setFont:[UIFont systemFontOfSize:14]];
    if ([unt  isKindOfClass:[department class]])
    {
        unitName.text = ((department*)unt).dept_name;
    }
    else if([unt  isKindOfClass:[person class]])
    {
        unitName.text = ((person*)unt).name_full;
    }
    //.text = @"1234567890abcdefghijklmnopqrstuvwxyzxyznowyousayicansaytheabc";
    
    expandBtn.tag = tag;
    
    if (!unt.isDept)
    {
        expandBtn.hidden = YES;
    }
    else
    {
        expandBtn.hidden = NO;
    }

}

@end
