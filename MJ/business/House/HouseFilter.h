//
//  HouseFilter
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dic2Object.h"

@interface HouseFilter : dic2Object

//job_no	String	用户名
//acc_password	String	密码
//consignment_type	String	委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2”
//@property (nonatomic, retain)
//trade_type	String	房源类型:比如出售 是”100”，出租 是”101”
//（此参数在默认房源列表查询时必须有，字典表里有）
//sale_trade_state	Int	状态（出售）
//（此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）
//无效	6
//暂缓	99
//有效	0
//我售	2
//已售	3
//lease_trade_state	Int	状态（出租）
//（此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）
//暂缓	99
//我租	2
//已租	3
//无效	6
//有效	0
//hall_num	String	房屋类型的厅的数量:如2厅
//room_num	String	房屋类型的室的数量:如3室
//buildname	String	栋座，比如1号楼
//house_unit	String	单元，比如2单元
//house_fluor	String	楼层
//house_tablet	String	房号
//house_driect	String	朝向
//structure_area_from	String	指定最小面积,
//区间
//structure_area_to	String	指定最大面积
//housearea	String	区域:比如城内
//houseurban	String	片区:比如钟楼
//fitment_type	String	装修类型:比如精装
//house_floor_from	String	指定最小楼层
//house_floor_to	String	指定最大楼层
//sale_value_from	Float	最低价格,单位万
//sale_value_to	Float	最高价格,单位万
//lease_value_from	Float	最低价格,单位元/月
//lease_value_to	Float	最高价格,单位元/月
//keyword	String	搜索关键字（请输入楼盘名或交易编号）
//FromID	String	若指定此参数，则返回ID比FromID小的记录（即比FromID时间早的公告），默认为0
//Database: house_trade_no
//ToID	String	若指定此参数，则返回ID小于或等于ToID的记录，默认为0
//Count	Int	单页返回的
//录条数，最大不超过100，默认为10

@end

