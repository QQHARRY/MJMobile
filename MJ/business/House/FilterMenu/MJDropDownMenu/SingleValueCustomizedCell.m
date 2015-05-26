//
//  SingleValueCustomizedCell.m
//  MJ
//
//  Created by harry on 15/5/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "SingleValueCustomizedCell.h"

@implementation SingleValueCustomizedCell

-(void)awakeFromNib
{
    self.singleValueField.delegate = self;
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
