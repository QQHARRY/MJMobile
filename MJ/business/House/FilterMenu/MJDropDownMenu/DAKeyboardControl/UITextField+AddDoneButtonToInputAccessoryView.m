//
//  UITextField+AddDoneButtonToInputAccessoryView.m
//  MJ
//
//  Created by harry on 15/5/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UITextField+AddDoneButtonToInputAccessoryView.h"
#import "DoneToolbarButton.h"
#import "RFKeyboardToolbar.h"

@implementation UITextField (AddDoneButtonToInputAccessoryView)


-(void)addDoneBtn
{
    
    DoneToolbarButton *doneBtn = [DoneToolbarButton new];
    
    
    [RFKeyboardToolbar addToTextField:self withButtons:@[doneBtn]];
}
@end
