//
//  houseParticulars.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface HouseParticulars : dic2Object

@property(nonatomic,strong)NSString* buildings_name;
//String
//楼盘名称

@property(nonatomic,strong)NSString* urbanname;
//String
//区域

@property(nonatomic,strong)NSString* areaname;
//String
//片区

@property(nonatomic,strong)NSString* buildings_address;
//String
//地址

@property(nonatomic,strong)NSString* build_structure_area;
//float
//面积

@property(nonatomic,strong)NSString* hall_num;
//Int
//房屋类型的厅的数量:如2厅

@property(nonatomic,strong)NSString* room_num;
//Int
//房

@property(nonatomic,strong)NSString* kitchen_num;
//类型的
//的数量:如3室
//Int
//厨

@property(nonatomic,strong)NSString* toilet_num;
//Int
//卫

@property(nonatomic,strong)NSString* balcony_num;
//In
//
//阳台

@property(nonatomic,strong)NSString* tene_application;
//Int
//物业用途（用来区分是住宅还是车位等）
//不同的物业用途有不同的属性字段，详见其他说明

@property(nonatomic,strong)NSString* tene_type;
//Int
//物业类型

@property(nonatomic,strong)NSString* fitment_type;
//Int
//装修

@property(nonatomic,strong)NSString* house_driect;
//Int
//朝向

@property(nonatomic,strong)NSString* cons_elevator_brand;
//String
//电梯（如奥旳斯

@property(nonatomic,strong)NSString* facility_heating;
//String
//暖气

@property(nonatomic,strong)NSString* facility_gas;
//String
//燃气

@property(nonatomic,strong)NSString* build_year;
//Int
//建房年代

@property(nonatomic,strong)NSString* build_property;
//Int
//产权年限

@property(nonatomic,strong)NSString* use_situation;
//Int
//现状

@property(nonatomic,strong)NSString* house_floor;
//Int
//所在楼层

@property(nonatomic,strong)NSString* build_floor_count;
//Int
//总楼层

@property(nonatomic,strong)NSString* sale_value_total;
//Float
//总价(出售 万)

@property(nonatomic,strong)NSString* sale_value_single;
//Float
//单价(出售 元/平米)

@property(nonatomic,strong)NSString* value_bottom;
//Float
//底价（出售 万）

@property(nonatomic,strong)NSString* lease_value_total;
//Float
//总价(出租 元/月)

@property(nonatomic,strong)NSString* lease_value_single;
//Float
//单价(出租 元/月/平米)

@property(nonatomic,strong)NSString* client_remark;
//String
//备注

@property(nonatomic,strong)NSString* b_staff_describ;
//String
//房源描述

@property(nonatomic,strong)NSString* owner_staff_name;
//String
//经纪人姓名

@property(nonatomic,strong)NSString* owner_staff_dept;
//String
//经纪人所属部门

@property(nonatomic,strong)NSString* owner_company_no;
//String
//经纪人所属公司编号

@property(nonatomic,strong)NSString* owner_compony_name;
//String
//经纪人所属公司名称

@property(nonatomic,strong)NSString* owner_mobile;
//String
//经纪人电话

@property(nonatomic,strong)NSString* client_source;
//String
//信息来源

@property(nonatomic,strong)NSString* edit_permit;
//String
//是否有编辑权限
//0=无
//1=有
//如果有编辑权限就有查看保密信息的权限

@property(nonatomic,strong)NSString* secret_permit;
//String
//是

@property(nonatomic,strong)NSString* look_permit;
//有查看保密信息的权限
//String
//看房:
//预约
//有钥匙
//借钥匙
//直接

@property(nonatomic,strong)NSString* xqt;
//String
//主图

@property(nonatomic,strong)NSString* hxt;
//String
//户型图

@property(nonatomic,strong)NSString* snt;
//String
//室内图

@property(nonatomic,strong)NSString* trade_type;
//String
//房源类型:比如出售 是”100”，出租 是”101”
//租售 是"102"
//(这里和跟进的对象状态有关
// 出售：出售状态
// 出租：出租状态
// 租售：出售状态

@property(nonatomic,strong)NSString* sale_trade_state;
//出租状态）
// 
// String
// 状态（出售）

@property(nonatomic,strong)NSString* lease_trade_state;
//
// String
// 状态（出租）


@property(nonatomic,strong)NSString* house_rank;
// String
// 如果是
// 商铺，商住，厂房，仓库，地皮表示位置:值取字典表中的

@property(nonatomic,strong)NSString* shop_rank;
// 
// 车位表示车位类型：

@property(nonatomic,strong)NSString* carpot_rank;
 
// 写字楼表示级别:
@property(nonatomic,strong)NSString* office_rank;
 
 
@property(nonatomic,strong)NSString* house_depth;
// Float
// 进深

@property(nonatomic,strong)NSString* floor_height;
// Float
// 层高

@property(nonatomic,strong)NSString* floor_count;
// int
// 层数(里面有几层)

@property(nonatomic,strong)NSString* efficiency_rate;
// float
// 实用率(百分比)

@property(nonatomic,strong)NSString* buildings_picture;
// String
// 房源图片ID



@end
