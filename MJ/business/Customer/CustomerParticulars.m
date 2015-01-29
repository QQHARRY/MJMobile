//
//  CustomerParticulars.m
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "CustomerParticulars.h"

@implementation CustomerParticulars

@synthesize  business_requirement_no;//客源 ID
@synthesize  client_base_no;//客户编号
@synthesize  client_name;//客户姓名
@synthesize  client_level;//客户等级
@synthesize  requirement_status;//客源状态
@synthesize  client_gender;//客户性别
@synthesize  client_background;//客户类别
@synthesize  requirement_house_urban;//所属城区编号
@synthesize  house_urban;//所属城区名称
@synthesize  requirement_house_area;//所属片区编号
@synthesize  buildings_name;//所属楼名称
@synthesize  requirement_buildings_no;
@synthesize  business_requirement_type;//求租或求购
@synthesize  requirement_floor_from;//Int最低楼层要求
@synthesize  requirement_floor_to;//Int最高楼层要求
@synthesize  requirement_room_from;//Int最少卧室数量 要求
@synthesize  requirement_room_to;//Int最大卧室数量 要求
@synthesize  requirement_hall_from;//Int最少厅数量要 求
@synthesize  requirement_hall_to;//Int最大厅数量要 求
@synthesize  requirement_area_from;//最小面积要求
@synthesize  requirement_area_to;//String最大面积要求
@synthesize  requirement_client_source;//String客户来源
@synthesize  requirement_sale_price_from;//String//￼最低求购价格
@synthesize  requirement_sale_price_to;//最高求购价格
@synthesize  requirement_lease_price_from;//最低求租价格
@synthesize  requirement_lease_price_to;//最高求租价格
@synthesize  requirement_tene_application;//物业用途
@synthesize  requirement_tene_type;//物业类型
@synthesize  requirement_fitment_type;//装修类型
@synthesize  requirement_house_driect;//朝向
@synthesize  sale_price_unit;//求购价格单位
@synthesize  lease_price_unit;//求租价格单位
@synthesize  requirement_memo;//备注
@synthesize  name_full;//置业顾问名字
@synthesize  comp_no;//公司编号
@synthesize  dept_name;//部门名称
@synthesize  b_dept_no;//部门编号
@synthesize  edit_permit;//是否有编辑权 限0=无1=有 如果有编辑权 限就有查看保 密信息的权
@synthesize  secret_permit;//是否有查看保 密信息的权限


@end
