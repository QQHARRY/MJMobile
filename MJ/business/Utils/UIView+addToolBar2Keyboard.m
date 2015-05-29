//
//  UIView+addToolBar2Keyboard.m
//  MJ
//
//  Created by harry on 15/5/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIView+addToolBar2Keyboard.h"



@implementation UIView (AddToolBar2Keyboard)


-(UIToolbar*)addToolBarWithPrerious:(SEL)preriousHandler NextAction:(SEL)nextHandler DoneAction:(SEL) doneHandler
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    NSMutableArray*actionArr = [[NSMutableArray alloc] init];
    
    
    if (nextHandler != nil)
    {
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                    action:nextHandler];
        
        [actionArr addObject:nextButton];
    }
    
    if (preriousHandler != nil)
    {
        UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:preriousHandler];
        [actionArr addObject:prevButton];
    }
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (doneHandler)
    {
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:doneHandler];
        [actionArr addObject:space];
        [actionArr addObject:done];
    }
    
    toolBar.items = actionArr;

    return toolBar;
}




@end
