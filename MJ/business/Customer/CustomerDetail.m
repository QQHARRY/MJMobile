//
//  CustomerViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "CustomerDetail.h"

@interface CustomerDetail ()

@end

@implementation CustomerDetail

@synthesize business_requirement_no; // 客源 ID
@synthesize client_name; // 客户姓名
@synthesize business_requirement_type; // 求租或求购
@synthesize house_urban; // 需求区域
@synthesize requirement_floor_from; // 最低楼层要求
@synthesize requirement_floor_to; // 最gao楼层要求
@synthesize requirement_room_from; // 最少卧室数量 要求
@synthesize requirement_room_to; // 最da卧室数量 要求
@synthesize requirement_hall_from; // 最少ting数量 要求
@synthesize requirement_hall_to; // 最da ting数量 要求
@synthesize requirement_sale_price_from; // 最低求购价格
@synthesize requirement_sale_price_to; // 最gao求购价格
@synthesize requirement_lease_price_from; // 最低求购价格
@synthesize requirement_lease_price_to; // 最gao求购价格
@synthesize sale_price_unit; // 求购价格单位
@synthesize lease_price_unit; // 求租价格单位
@synthesize requirement_area_from; // 最小面积要求
@synthesize requirement_area_to; // 最da面积要求
@synthesize buildings_create_time; // 登记日期

@end


