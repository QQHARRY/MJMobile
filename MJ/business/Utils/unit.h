//
//  unit.h
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface unit : dic2Object

@property(assign,nonatomic)BOOL isDept;
@property(assign,nonatomic)int level;
@property(strong,nonatomic)unit*superUnit;
@property(strong,nonatomic)NSMutableArray* subDept;
@property(strong,nonatomic)NSMutableArray* subPerson;
@property(assign,nonatomic)BOOL closed;

-(BOOL)hasSubUnits;



-(long)numberOfSubUnits;
-(unit*)findSubUnitByIndex:(NSInteger*)index;

-(void)setSubUnits:(NSArray*)units;
-(unit*)findSuperUnitOfUnit:(unit*)unt;
@end
