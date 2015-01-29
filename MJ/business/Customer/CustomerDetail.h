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

@property (nonatomic, strong) NSString *business_requirement_no; // 客源 ID
@property (nonatomic, strong) NSString *client_name; // 客户姓名
@property (nonatomic, strong) NSString *business_requirement_type; // 求租或求购
@property (nonatomic, strong) NSString *house_urban; // 需求区域
@property (nonatomic, strong) NSString *requirement_floor_from; // 最低楼层要求
@property (nonatomic, strong) NSString *requirement_floor_to; // 最gao楼层要求
@property (nonatomic, strong) NSString *requirement_room_from; // 最少卧室数量 要求
@property (nonatomic, strong) NSString *requirement_room_to; // 最da卧室数量 要求
@property (nonatomic, strong) NSString *requirement_hall_from; // 最少ting数量 要求
@property (nonatomic, strong) NSString *requirement_hall_to; // 最da ting数量 要求
@property (nonatomic, strong) NSString *requirement_sale_price_from; // 最低求购价格
@property (nonatomic, strong) NSString *requirement_sale_price_to; // 最gao求购价格
@property (nonatomic, strong) NSString *requirement_lease_price_from; // 最低求购价格
@property (nonatomic, strong) NSString *requirement_lease_price_to; // 最gao求购价格
@property (nonatomic, strong) NSString *sale_price_unit; // 求购价格单位
@property (nonatomic, strong) NSString *lease_price_unit; // 求租价格单位
@property (nonatomic, strong) NSString *requirement_area_from; // 最小面积要求
@property (nonatomic, strong) NSString *requirement_area_to; // 最da面积要求
@property (nonatomic, strong) NSString *buildings_create_time; // 登记日期

@end

// eg:
//"area_dept_no" = "";
//"b_dept_no" = "";
//"b_job_no" = "";
//"b_register_surplus_day" = "";
//"b_register_type" = "";
//"b_staff_describ" = "";
//"b_staff_title" = "";
//"buildings_create_date" = "";
//"buildings_create_job_no" = "";
//"buildings_create_time" = "2015-01-07 14:23:22";
//"buildings_edit_date" = "";
//"buildings_edit_job_no" = "";
//"buildings_edit_time" = "";
//"buildings_name" = "";
//"buildings_opt_no" = "";
//"buildings_staff_no" = "";
//"business_requirement_no" = "B_C_R_NO0000015690";
//"business_requirement_type" = 201;
//"client_background" = "";
//"client_base_no" = "";
//"client_birthday" = "";
//"client_gender" = "";
//"client_identity" = "";
//"client_identity_type" = "";
//"client_level" = "";
//"client_name" = "\U5e38";
//"client_obj_contact_no" = "";
//"client_owner_no" = "";
//"client_remark" = "";
//"client_salutation" = "";
//"client_type" = "";
//"comp_no" = "";
//"del_flag" = "";
//"dept_current_no" = "";
//"dept_name" = "";
//"dept_parents_no" = "";
//"edit_permit" = "";
//"fitment_type" = "";
//followNum = "";
//"house_area" = "";
//"house_driect" = "";
//"house_urban" = "\U548c\U5e73\U95e8\U57ce\U5357";
//"lease_price_unit" = "\U5143/\U6708";
//"name_full" = "";
//"obj_address" = "";
//"obj_city" = "";
//"obj_contact_no" = "";
//"obj_country" = "";
//"obj_email" = "";
//"obj_fax" = "";
//"obj_fixtel" = "";
//"obj_fixtel_dial" = "";
//"obj_hurry_relation" = "";
//"obj_hurry_relation_tel" = "";
//"obj_memo" = "";
//"obj_mobile" = "";
//"obj_msn" = "";
//"obj_no" = "";
//"obj_postcode" = "";
//"obj_province" = "";
//"obj_qq" = "";
//"obj_type" = "";
//"obj_web" = "";
//"obj_weixin" = "";
//"requirement_area" = "";
//"requirement_area_from" = 129;
//"requirement_area_to" = 125;
//"requirement_buildings_no" = "";
//"requirement_client_source" = "";
//"requirement_fitment_type" = "";
//"requirement_floor" = "";
//"requirement_floor_from" = 5;
//"requirement_floor_to" = 10;
//"requirement_hall" = "";
//"requirement_hall_from" = 2;
//"requirement_hall_to" = 1;
//"requirement_house_area" = "";
//"requirement_house_driect" = "";
//"requirement_house_urban" = "";
//"requirement_lease_pay_type" = "";
//"requirement_lease_price_from" = "150.00";
//"requirement_lease_price_to" = "150.00";
//"requirement_lease_price_unit" = "";
//"requirement_memo" = "";
//"requirement_room" = "";
//"requirement_room_from" = 3;
//"requirement_room_to" = 2;
//"requirement_sale_pay_type" = "";
//"requirement_sale_price_from" = "";
//"requirement_sale_price_to" = "";
//"requirement_sale_price_unit" = "";
//"requirement_status" = "";
//"requirement_tene_application" = "";
//"requirement_tene_type" = "";
//"sale_price_unit" = "\U4e07\U5143";
//"secret_permit" = "";
//"staff_detail_no" = "";


