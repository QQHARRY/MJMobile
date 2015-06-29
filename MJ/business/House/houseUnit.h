//
//  houseUnit.h
//  MJ
//
//  Created by harry on 15/6/29.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface houseUnit : dic2Object

//unit_no
//String
//单元编号
@property(nonatomic,strong)NSString* unit_no;

//
//unit_name
//String
//单元名称
@property(nonatomic,strong)NSString* unit_name;

//
//floor_count
//String
//单元总层数
@property(nonatomic,strong)NSString* floor_count;


//
//elevator_count
//String
//单元电梯数
@property(nonatomic,strong)NSString* elevator_count;


//
//house_count
//String
//单元每层户数
@property(nonatomic,strong)NSString* house_count;

@end
