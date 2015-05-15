//
//  UIImageView+LoadPortraitOfPerson.h
//  MJ
//
//  Created by harry on 15/5/8.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "person.h"

@interface UIImageView (LoadPortraitOfPerson)

-(void)loadPortraitOfPerson:(person*)psn;
-(void)loadPortraitOfPerson:(person*)psn round:(BOOL)round;
-(void)loadPortraitOfPerson:(person*)psn withDefault:(UIImage*)image round:(BOOL)round;
-(void)loadPortraitOfPerson:(person*)psn withDefault:(UIImage*)image;
-(void)loadPortraitOfUser:(NSString*)userName;
//-(void)quickLoadPortraitOfUser:(NSString*)userName;
@end
