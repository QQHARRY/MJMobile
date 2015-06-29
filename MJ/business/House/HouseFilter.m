//
//  HouseFilter
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseFilter.h"

@interface HouseFilter ()

@end

@implementation HouseFilter

//job_no	String	用户名 *
//acc_password	String	密码 *
//consignment_type	String	委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” *
@synthesize consignment_type;
//trade_type	String	房源类型:比如出售 是”100”，出租 是”101” *
//（此参数在默认房源列表查询时必须有，字典表里有）
@synthesize trade_type;
//sale_state	Int	状态（出售）*
//（此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）
//无效	6
//暂缓	99
//有效	0
//我售	2
//已售	3
@synthesize sale_state;
//lease_state	Int	状态（出租）*
//（此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）
//暂缓	99
//我租	2
//已租	3
//无效	6
//有效	0
@synthesize lease_state;
//hall_num	String	房屋类型的厅的数量:如2厅
@synthesize hall_num;
//room_num	String	房屋类型的室的数量:如3室
@synthesize room_num;
//buildname	String	栋座，比如1号楼
@synthesize buildname;
//house_unit	String	单元，比如2单元
@synthesize unit_name;
//house_fluor	String	楼层
@synthesize house_floor;
//house_tablet	String	房号
@synthesize house_tablet;
//house_driect	String	朝向
@synthesize house_driect;
//structure_area_from	String	指定最小面积,
//区间
@synthesize structure_area_from;
//structure_area_to	String	指定最大面积
@synthesize structure_area_to;
//housearea	String	区域:比如城内
@synthesize house_area;
//houseurban	String	片区:比如钟楼
@synthesize house_urban;
//fitment_type	String	装修类型:比如精装
@synthesize fitment_type;
//house_floor_from	String	指定最小楼层
@synthesize house_floor_from;
//house_floor_to	String	指定最大楼层
@synthesize house_floor_to;
//sale_value_from	Float	最低价格,单位万
@synthesize sale_value_from;
//sale_value_to	Float	最高价格,单位万
@synthesize sale_value_to;
//lease_value_from	Float	最低价格,单位元/月
@synthesize lease_value_from;
//lease_value_to	Float	最高价格,单位元/月
@synthesize lease_value_to;
// search_job_no String 指定查询员工编号
@synthesize search_job_no;
//search_dept_no String 指定查询部门编号
@synthesize search_dept_no;
//keyword	String	搜索关键字（请输入楼盘名或交易编号）
@synthesize Keyword;
//FromID	String	若指定此参数，则返回ID比FromID小的记录（即比FromID时间早的公告），默认为0 Database: trade_no *
@synthesize FromID;
//ToID	String	若指定此参数，则返回ID小于或等于ToID的记录，默认为0 *
@synthesize ToID;
//Count	Int	单页返回的录条数，最大不超过100，默认为10 *
@synthesize Count;

@end