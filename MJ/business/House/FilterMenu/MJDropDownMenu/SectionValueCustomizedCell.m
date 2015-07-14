//
//  SectionValueCustomizedCell.m
//  MJ
//
//  Created by harry on 15/5/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "SectionValueCustomizedCell.h"
#import "UITextField+AddDoneButtonToInputAccessoryView.h"


@interface SectionValueCustomizedCell()
@property(nonatomic,strong)NSString*oldMinValue;
@property(nonatomic,strong)NSString*oldMaxValue;
@end

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
    if (textField == self.minValue)
    {
        self.oldMinValue = textField.text;
    }
    else if(textField == self.maxValue)
    {
        self.oldMaxValue = textField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.minValue)
    {
        if (![textField.text isEqualToString:self.oldMinValue])
        {
            if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(SectionCell:TextField:oldValue:atIndex:)])
            {
                [self.textFieldDelegate SectionCell:self TextField:textField oldValue:self.oldMinValue atIndex:0];
            }
        }
    }
    else if(textField == self.maxValue)
    {
        if (![textField.text isEqualToString:self.oldMaxValue])
        {
            if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(SectionCell:TextField:oldValue:atIndex:)])
            {
                [self.textFieldDelegate SectionCell:self TextField:textField oldValue:self.oldMaxValue atIndex:1];
            }
        }
    }
    

}


-(void)setKeyBoardType:(UIKeyboardType)kbType
{
    self.minValue.keyboardType = kbType;
    self.maxValue.keyboardType = kbType;
}


@end
