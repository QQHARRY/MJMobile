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
     -(void)loadPortraitOfUser:(NSString*)userName;
-(void)quickLoadPortraitOfUser:(NSString*)userName;
@end
