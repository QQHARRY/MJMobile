//
//  CustomerDetail
//  MJ
//
//  Created by harry on 14-11-23.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dic2Object.h"

@interface CustomerDetail : dic2Object

@property (nonatomic, strong) NSString *Customer_trade_no; // 房源索引号或ID
@property (nonatomic, strong) NSString *buildings_name; // 楼盘名
@property (nonatomic, strong) NSString *buildname; // 栋座
@property (nonatomic, strong) NSString *Customer_unit; // 单元
@property (nonatomic, strong) NSString *areaname; // 片区名
@property (nonatomic, strong) NSString *urbanname; // 城区名
@property (nonatomic, strong) NSString *Customer_driect; // 朝向
@property (nonatomic, strong) NSString *build_structure_area; // 面积
@property (nonatomic, strong) NSString *Customer_floor; // 所在楼层
@property (nonatomic, strong) NSString *floor_count; // 总楼层
@property (nonatomic, strong) NSString *sale_value_total; // 总价(出售 万)
@property (nonatomic, strong) NSString *Sale_value_single; // 单价(出售 元/平 米)
@property (nonatomic, strong) NSString *lease_value_total; // 总价(出租 元/ 月)
@property (nonatomic, strong) NSString *lease_value_single; // 单价(出租 元/ 月/平米)
@property (nonatomic, strong) NSString *room_num; // 房
@property (nonatomic, strong) NSString *kitchen_num; // 厨
@property (nonatomic, strong) NSString *hall_num; // 厅
@property (nonatomic, strong) NSString *toilet_num; // 卫
@property (nonatomic, strong) NSString *sale_trade_state; // 状态(出售)
@property (nonatomic, strong) NSString *lease_trade_state; // 状态(出租)
@property (nonatomic, strong) NSString *fitment_type; // 装修类型
@property (nonatomic, strong) NSString *ThumbnailUrl; // 缩略图url(也就 是一张主图的 图片路径)
@property (nonatomic, strong) NSString *consignment_type; // 委托类型 ID

@end

// eg:
//    ThumbnailUrl = "";
//     = "\U957f\U4e50\U4e1c\U8def";
//    "" = "";
//    "" = "";
//    "" = "";
//    "" = "";
//    "" = "";
//    "" = 88;
//    "" = "";
//    "buildings_name" = "\U5fa1\U9526\U57ce";
//    "buildings_no" = "";
//    "buildings_picture" = "PHOTO_NO0000067435";
//    buildname = "04\U680b";
//    "client_no" = "";
//    "consignment_type" = 1;
//    "contract_app_date" = "";
//    "efficiency_rate" = "";
//    "elevator_count" = "";
//    "fitment_type" = 3;
//    "floor_count" = 18;
//    "floor_height" = "";
//    "hall_num" = 2;
//    "Customer_area" = "";
//    "Customer_count" = "";
//    "Customer_depth" = "";
//    "Customer_driect" = 0;
//    "Customer_floor" = 16;
//    "Customer_floor_count" = "";
//    "Customer_key_no" = "";
//    "Customer_rank" = "";
//    "Customer_trade_no" = "HT_0000035417";
//    "Customer_unit" = 1;
//    "Customer_urban" = "";
//    "kitchen_num" = 1;
//    "lease_trade_state" = 0;
//    "lease_value_single" = "0.00";
//    "lease_value_total" = "0.00";
//    "look_permit" = "";
//    "owner_comp_no" = "";
//    "owner_staff_dept" = "";
//    "owner_staff_name" = "";
//    "room_num" = 2;
//    "sale_trade_state" = 0;
//    "sale_value_single" = "6818.18";
//    "sale_value_total" = "600000.00";
//    "task_follow_time" = "";
//    "tene_application" = "";
//    "toilet_num" = 1;
//    "trade_type" = 100;
//    urbanname = "\U57ce\U4e1c";
//    "use_situation" = "";
//}

    

