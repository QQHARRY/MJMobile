//
//  UIView+addToolBar2Keyboard.h
//  MJ
//
//  Created by harry on 15/5/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddToolBar2Keyboard)


-(UIToolbar*)addToolBarWithPrerious:(SEL)preriousHandler NextAction:(SEL)nextHandler DoneAction:(SEL) donHandler;

@end
