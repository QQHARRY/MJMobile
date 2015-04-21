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

//按索引顺序号获取，在一个按照用户操作展开的树状结构中的某个节点
-(unit*)findSubUnitByIndex:(NSInteger*)index;

//建立本节点以下的树状结构
-(void)setSubUnits:(NSArray*)units;

//全树搜索某个节点逻辑上的父节点(寻找该节点的插入位置)
-(unit*)findSuperUnitOfUnit:(unit*)unt;
@end
