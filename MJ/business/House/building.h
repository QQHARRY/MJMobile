//
//  building.h
//  MJ
//
//  Created by harry on 15/1/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface building : dic2Object


@property(strong,nonatomic)NSString*building_name;
@property(strong,nonatomic)NSString*building_no;
@property(strong,nonatomic)NSString*unit_count;
//@property(strong,nonatomic)NSString*floor_count;
//@property(strong,nonatomic)NSString*elevator_house;

-(NSArray*)getSerialArr;
@end
