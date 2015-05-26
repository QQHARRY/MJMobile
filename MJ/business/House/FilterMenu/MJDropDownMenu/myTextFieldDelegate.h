//
//  myTextFieldDelegate.h
//  MJ
//
//  Created by harry on 18/5/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//



@protocol myTextFieldDelegate <NSObject>

@optional

-(void)myTextFieldDidBeginEditing;
- (void)myTextFieldShouldReturn;


@end