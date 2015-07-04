//
//  SectionValueCustomizedCell.m
//  MJ
//
//  Created by harry on 15/5/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "SectionValueCustomizedCell.h"
#import "UITextField+AddDoneButtonToInputAccessoryView.h"

@implementation SectionValueCustomizedCell


-(void)awakeFromNib
{
    self.minValue.delegate = self;
    self.maxValue.delegate = self;
    
    [self.minValue addDoneBtn];
    [self.maxValue addDoneBtn];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(myTextFieldDidBeginEditing)])
    {
        [self.textFieldDelegate myTextFieldDidBeginEditing];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(myTextFieldShouldReturn)])
    {
        [self.textFieldDelegate myTextFieldShouldReturn];
    }
    
    return YES;
}


@end