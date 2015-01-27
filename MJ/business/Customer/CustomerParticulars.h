//
//  CustomerParticulars.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface CustomerParticulars : dic2Object

@property(nonatomic,strong) NSString *business_requirement_no;//客源 ID
@property(nonatomic,strong) NSString *client_base_no;//客户编号
@property(nonatomic,strong) NSString *client_name;//客户姓名
@property(nonatomic,strong) NSString *client_level;//客户等级
@property(nonatomic,strong) NSString *requirement_status;//客源状态
@property(nonatomic,strong) NSString *client_gender;//客户性别
@property(nonatomic,strong) NSString *client_background;//客户类别
@property(nonatomic,strong) NSString *requirement_house_urban;//所属城区编号
@property(nonatomic,strong) NSString *house_urban;//所属城区名称
@property(nonatomic,strong) NSString *requirement_house_area;//所属片区编号
@property(nonatomic,strong) NSString *buildings_name;//所属楼名称
@property(nonatomic,strong) NSString *requirement_buildings_no;//所属楼盘编号
@property(nonatomic,strong) NSString *business_requirement_type;//求租或求购
@property(nonatomic,strong) NSString *requirement_floor_from;//Int最低楼层要求
@property(nonatomic,strong) NSString *requirement_floor_to;//Int最高楼层要求
@property(nonatomic,strong) NSString *requirement_room_from;//Int最少卧室数量 要求
@property(nonatomic,strong) NSString *requirement_room_to;//Int最大卧室数量 要求
@property(nonatomic,strong) NSString *requirement_hall_from;//Int最少厅数量要 求
@property(nonatomic,strong) NSString *requirement_hall_to;//Int最大厅数量要 求
@property(nonatomic,strong) NSString *requirement_area_from;//最小面积要求
@property(nonatomic,strong) NSString *requirement_area_to;//String最大面积要求
@property(nonatomic,strong) NSString *requirement_client_source;//String客户来源
@property(nonatomic,strong) NSString *requirement_sale_price_from;//String//￼最低求购价格
@property(nonatomic,strong) NSString *requirement_sale_price_to;//最高求购价格
@property(nonatomic,strong) NSString *requirement_lease_price_from;//最低求租价格
@property(nonatomic,strong) NSString *requirement_lease_price_to;//最高求租价格
@property(nonatomic,strong) NSString *requirement_tene_application;//物业用途
@property(nonatomic,strong) NSString *requirement_tene_type;//物业类型
@property(nonatomic,strong) NSString *requirement_fitment_type;//装修类型
@property(nonatomic,strong) NSString *requirement_house_driect;//朝向
@property(nonatomic,strong) NSString *sale_price_unit;//求购价格单位
@property(nonatomic,strong) NSString *lease_price_unit;//求租价格单位
@property(nonatomic,strong) NSString *requirement_memo;//备注
@property(nonatomic,strong) NSString *name_full;//置业顾问名字
@property(nonatomic,strong) NSString *comp_no;//公司编号
@property(nonatomic,strong) NSString *dept_name;//部门名称
@property(nonatomic,strong) NSString *b_dept_no;//部门编号
@property(nonatomic,strong) NSString *edit_permit;//是否有编辑权 限0=无1=有 如果有编辑权 限就有查看保 密信息的权限
@property(nonatomic,strong) NSString *secret_permit;//是否有查看保 密信息的权限

@end
