//
//  SingleValueCustomizedCell.m
//  MJ
//
//  Created by harry on 15/5/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "SingleValueCustomizedCell.h"
#import "UITextField+AddDoneButtonToInputAccessoryView.h"


@interface SingleValueCustomizedCell()

@property(nonatomic,strong)NSString*oldValue;
@end

@implementation SingleValueCustomizedCell

-(void)awakeFromNib
{
    self.singleValueField.delegate = self;
    [self.singleValueField addDoneBtn];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.oldValue = textField.text;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:self.oldValue])
    {
        if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(singleCell:TextField:oldValue:)])
        {
            [self.textFieldDelegate singleCell:self TextField:textField oldValue:textField.text];
        }
    }
    
}

-(void)setKeyBoardType:(UIKeyboardType)kbType
{
    self.singleValueField.keyboardType = kbType;
}



@end
