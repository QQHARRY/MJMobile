//
//  ContactsListTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/16.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ContactsListTableViewCell.h"
#import "department.h"
#import "person.h"

#define kLevelOffset    15

@implementation ContactsListTableViewCell
@synthesize unitName;
@synthesize expandBtn;
@synthesize selectBtn;

- (void)awakeFromNib {
    // Initialization code
    self.shouldIndentWhileEditing = YES;
    
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

-(void)setUnit:(unit*)unt withTag:(long)tag delegate:(id)dele action:(SEL)action  Selected:(BOOL)selected
{
    self.unitKeeped = unt;
    _level = unt.level;
    self.delegate = dele;
    self.action = action;
    
    
    expandBtn =[[UIButton alloc] initWithFrame:CGRectMake(5+kLevelOffset*_level, 0, 44, 44)];
    unitName = [[UILabel alloc] initWithFrame:CGRectMake(50+kLevelOffset*_level,10, 200, 21)];
    unitName.font = [UIFont systemFontOfSize:17];
    [expandBtn addTarget:self action:@selector(expandBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 10, 20, 20)];
    
    
    
    [self addSubview:expandBtn];
    [self addSubview:unitName];
    [self addSubview:selectBtn];
    
   
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

    
    if (selected)
    {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"ButtonCheck"] forState:UIControlStateNormal];
    }
    else
    {
        [selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
}

-(void)setBeSelected:(BOOL)selected
{
    if (selected)
    {
        [selectBtn setBackgroundImage:[UIImage imageNamed:@"ButtonCheck"] forState:UIControlStateNormal];
    }
    else
    {
        [selectBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

@end
