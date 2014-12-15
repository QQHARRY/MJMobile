//
//  unit.h
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface unit : NSObject

@property(assign,nonatomic)BOOL isDept;
@property(assign,nonatomic)int level;
@property(strong,nonatomic)unit*superUnit;
@property(strong,nonatomic)NSArray* subUnits;

@end
