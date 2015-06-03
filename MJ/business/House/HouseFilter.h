//
//  HouseFilter
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseFilter : NSObject

//job_no	String	用户名 *
//acc_password	String	密码 *
//consignment_type	String	委托类型：A-独家 是”0”、B-一般 是”1”、C-未签 是”2” *
@property (nonatomic, strong) NSString *consignment_type;
//trade_type	String	房源类型:比如出售 是”100”，出租 是”101” *
//（此参数在默认房源列表查询时必须有，字典表里有）
@property (nonatomic, strong) NSString *trade_type;
//sale_trade_state	Int	状态（出售）*
//（此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）
//无效	6
//暂缓	99
//有效	0
//我售	2
//已售	3
@property (nonatomic, strong) NSString *sale_trade_state;
//lease_trade_state	Int	状态（出租）*
//（此参数在默认房源列表查询时必须有(默认查有效)，字典表里有）
//暂缓	99
//我租	2
//已租	3
//无效	6
//有效	0
@property (nonatomic, strong) NSString *lease_trade_state;
//hall_num	String	房屋类型的厅的数量:如2厅
@property (nonatomic, strong) NSString *hall_num;
//room_num	String	房屋类型的室的数量:如3室
@property (nonatomic, strong) NSString *room_num;
//buildname	String	栋座，比如1号楼
@property (nonatomic, strong) NSString *buildname;
//house_unit	String	单元，比如2单元
@property (nonatomic, strong) NSString *house_unit;
//house_fluor	String	楼层
@property (nonatomic, strong) NSString *house_fluor;
//house_tablet	String	房号
@property (nonatomic, strong) NSString *house_tablet;
//house_driect	String	朝向
@property (nonatomic, strong) NSString *house_driect;
//structure_area_from	String	指定最小面积,
//区间
@property (nonatomic, strong) NSString *structure_area_from;
//structure_area_to	String	指定最大面积
@property (nonatomic, strong) NSString *structure_area_to;
//housearea	String	区域:比如城内
@property (nonatomic, strong) NSString *housearea;
//houseurban	String	片区:比如钟楼
@property (nonatomic, strong) NSString *houseurban;
//fitment_type	String	装修类型:比如精装
@property (nonatomic, strong) NSString *fitment_type;
//house_floor_from	String	指定最小楼层
@property (nonatomic, strong) NSString *house_floor_from;
//house_floor_to	String	指定最大楼层
@property (nonatomic, strong) NSString *house_floor_to;
//sale_value_from	Float	最低价格,单位万
@property (nonatomic, strong) NSString *sale_value_from;
//sale_value_to	Float	最高价格,单位万
@property (nonatomic, strong) NSString *sale_value_to;
//lease_value_from	Float	最低价格,单位元/月
@property (nonatomic, strong) NSString *lease_value_from;
//lease_value_to	Float	最高价格,单位元/月
@property (nonatomic, strong) NSString *lease_value_to;
// search_job_no String 指定查询员工编号
@property (nonatomic, strong) NSString *search_job_no;
//search_dept_no String 指定查询部门编号
@property (nonatomic, strong) NSString *search_dept_no;
//keyword	String	搜索关键字（请输入楼盘名或交易编号）
@property (nonatomic, strong) NSString *keyword;
//FromID	String	若指定此参数，则返回ID比FromID小的记录（即比FromID时间早的公告），默认为0 Database: house_trade_no *
@property (nonatomic, strong) NSString *FromID;
//ToID	String	若指定此参数，则返回ID小于或等于ToID的记录，默认为0 *
@property (nonatomic, strong) NSString *ToID;
//Count	Int	单页返回的录条数，最大不超过100，默认为10 *
@property (nonatomic, strong) NSString *Count;

@end

