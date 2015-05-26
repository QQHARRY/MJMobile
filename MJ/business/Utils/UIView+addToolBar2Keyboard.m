//
//  UIView+addToolBar2Keyboard.m
//  MJ
//
//  Created by harry on 15/5/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "UIView+addToolBar2Keyboard.h"
#import "DaiDodgeKeyboard.h"


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
    
    
//    for (UIView *v in self.subviews)
//    {
//        if ([v respondsToSelector:@selector(setText:)])
//        {
//            [v performSelector:@selector(setDelegate:) withObject:self];
//            [v performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
//        }
//        else if([v isKindOfClass:[UITableViewCell class]])
//        {
//            for (UIView*v1 in v.subviews)
//            {
//                if ([v1 respondsToSelector:@selector(setText:)])
//                {
//                    [v1 performSelector:@selector(setDelegate:) withObject:self];
//                    [v1 performSelector:@selector(setInputAccessoryView:) withObject:toolBar];
//                }
//            }
//        }
//    }
    
    [DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self];
    return toolBar;
}




@end
