//
//  EaseMobContacter.h
//  MJ
//
//  Created by harry on 15/5/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "person.h"
#import "EMBuddy.h"

@interface EaseMobContacter : NSObject


@property(strong,atomic)EMBuddy*buddy;
@property(strong,atomic)person*psn;
@property(assign,atomic)BOOL isFriend;


@property(strong,atomic)NSMutableArray*requestBlock;

-(id)initWithBuddy:(EMBuddy*)buddy Person:(person*)psn;
@end
