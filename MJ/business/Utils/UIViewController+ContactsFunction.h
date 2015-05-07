//
//  UIViewController+_ContactsFunction.h
//  MJ
//
//  Created by harry on 15/5/7.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "person.h"

@interface UIViewController (ContactsFunction)

-(void)ct_onImMessage:(person*)psn;

-(void)ct_onAddFriend:(person*)psn;

-(void)ct_onCall:(person*)psn;
-(void)ct_onShortMessage:(person*)psn;

@end
