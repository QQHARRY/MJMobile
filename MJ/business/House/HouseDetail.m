//
//  HouseViewController.m
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseDetail.h"

@interface HouseDetail ()

@end

@implementation HouseDetail

@synthesize trade_no; // 房源索引号或ID
@synthesize domain_name; // 楼盘名
@synthesize building_name; // 栋座
@synthesize unit_name; // 单元
@synthesize areaname; // 片区名
@synthesize urbanname; // 城区名
@synthesize house_driect; // 朝向
@synthesize structure_area; // 面积
@synthesize house_floor; // 所在楼层
@synthesize floor_count; // 总楼层
@synthesize sale_listing; // 总价(出售 万)
@synthesize sale_single; // 单价(出售 元/平 米)
@synthesize rent_listing; // 总价(出租 元/ 月)
@synthesize rent_single; // 单价(出租 元/ 月/平米)
@synthesize room_num; // 房
@synthesize kitchen_num; // 厨
@synthesize hall_num; // 厅
@synthesize toilet_num; // 卫
@synthesize sale_state; // 状态(出售)
@synthesize lease_state; // 状态(出租)
@synthesize fitment_type; // 装修类型
@synthesize ThumbnailUrl; // 缩略图url(也就 是一张主图的 图片路径)
@synthesize consignment_type; // 委托类型 ID
@synthesize look_permit;
@synthesize reg_type; //0：个人私盘；1：门店公盘；2：区域公盘；3：大区域公盘；99：公司公盘
@synthesize reg_surplus; //剩余天数

-(int)getRegTypeInt
{
    if (self.reg_type && self.reg_type.length > 0)
    {
        int iRegType = [self.reg_type intValue];
        return iRegType;
    }
    
    return 0;
}
@end


