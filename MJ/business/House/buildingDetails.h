//
//  buildingDetails.h
//  MJ
//
//  Created by harry on 15/1/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface buildingDetails : dic2Object

@property(strong,nonatomic)NSString* domain_name;
//String
//楼盘名称

@property(strong,nonatomic)NSString* urbanname;
//String
//区域

@property(strong,nonatomic)NSString* areaname;
//String
//片区

@property(strong,nonatomic)NSString* domain_address;
//String
//地址

@property(strong,nonatomic)NSString* tene_application;
//String
//物业用途（多个用途时用逗号隔开）


@property(strong,nonatomic)NSString* cons_elevator_brand;
//String
//电梯（如奥旳斯）

@property(strong,nonatomic)NSString* facility_heating;
//String
//暖气

@property(strong,nonatomic)NSString* facility_gas;
//String
//燃气




@end
