//
//  DoneToolbarButton.m
//  MJ
//
//  Created by harry on 15/5/26.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "DoneToolbarButton.h"

@implementation DoneToolbarButton

- (NSString*)titleForButton {
    return @"完成";
}

- (void)buttonTarget {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


@end
