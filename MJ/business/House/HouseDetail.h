//
//  HouseDetail
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dic2Object.h"

@interface HouseDetail : dic2Object

@property (nonatomic, strong) NSString *trade_no; // 房源索引号或ID
@property (nonatomic, strong) NSString *domain_name; // 楼盘名
@property (nonatomic, strong) NSString *building_name; // 栋座
@property (nonatomic, strong) NSString *unit_name; // 单元
@property (nonatomic, strong) NSString *areaname; // 片区名
@property (nonatomic, strong) NSString *urbanname; // 城区名
@property (nonatomic, strong) NSString *house_driect; // 朝向
@property (nonatomic, strong) NSString *structure_area; // 面积
@property (nonatomic, strong) NSString *house_floor; // 所在楼层
@property (nonatomic, strong) NSString *floor_count; // 总楼层
@property (nonatomic, strong) NSString *sale_listing; // 总价(出售 万)
@property (nonatomic, strong) NSString *sale_single; // 单价(出售 元/平 米)
@property (nonatomic, strong) NSString *rent_listing; // 总价(出租 元/ 月)
@property (nonatomic, strong) NSString *rent_single; // 单价(出租 元/ 月/平米)
@property (nonatomic, strong) NSString *room_num; // 房
@property (nonatomic, strong) NSString *kitchen_num; // 厨
@property (nonatomic, strong) NSString *hall_num; // 厅
@property (nonatomic, strong) NSString *toilet_num; // 卫
@property (nonatomic, strong) NSString *sale_state; // 状态(出售)
@property (nonatomic, strong) NSString *lease_state; // 状态(出租)
@property (nonatomic, strong) NSString *fitment_type; // 装修类型
@property (nonatomic, strong) NSString *album_thumb_path; // 缩略图url(也就 是一张主图的 图片路径)
@property (nonatomic, strong) NSString *consignment_type; // 委托类型 ID
@property (nonatomic, strong) NSString *look_permit; //看房(预约，有钥匙，借钥匙，直接)

@property (nonatomic, strong) NSString *reg_type; //0：个人私盘；1：门店公盘；2：区域公盘；3：大区域公盘；99：公司公盘

@property (nonatomic, strong) NSString *reg_surplus; //剩余天数

-(int)getRegTypeInt;

@end



    

