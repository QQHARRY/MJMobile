//
//  addCustomerTableViewController.h
//  MJ
//
//  Created by harry on 15/1/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"

@interface addCustomerTableViewController : UITableViewController<RETableViewManagerDelegate>

@property(strong,nonatomic)RETableViewManager*manager;
@property(strong,nonatomic)RETableViewSection*customerBaseInfoSection;
@property(strong,nonatomic)RETableViewSection*customerRequireSection;
@property(strong,nonatomic)RETableViewSection*tradeTypeSection;
@property(strong,nonatomic)RETableViewSection*remarkSection;
@property(strong,nonatomic)RETableViewSection*staffSection;


@property(nonatomic,strong) RERadioItem *requirement_status;//客源状态
@property(nonatomic,strong) RETextItem *client_name;//客户姓名
@property(nonatomic,strong) RERadioItem *client_gender;//客户性别
@property(nonatomic,strong) RERadioItem *client_level;//客户等级
@property(nonatomic,strong) RERadioItem *client_background;//客户类别
@property(nonatomic,strong) RETextItem *mobilePhone;//手机
@property(nonatomic,strong) RETextItem *fixPhone;//固话
@property(nonatomic,strong) RETextItem *idCardNO;//身份证
@property(nonatomic,strong) RETextItem *homeAddress;//家庭地址


@property(nonatomic,strong) RERadioItem *requirement_house_urban;//所属城区编号
@property(nonatomic,strong) RERadioItem *requirement_house_area;//所属片区编号
@property(nonatomic,strong) RERadioItem *buildings_name;//楼盘编号
@property(nonatomic,strong) RERadioItem *requirement_tene_application;//物业用途
@property(nonatomic,strong) RERadioItem *requirement_tene_type;//物业类型
@property(nonatomic,strong) RERadioItem *requirement_fitment_type;//装修类型
@property(nonatomic,strong) RERadioItem *requirement_house_driect;//朝向
@property(nonatomic,strong) RENumberItem *requirement_floor_from;//Int最低楼层要求
@property(nonatomic,strong) RENumberItem *requirement_floor_to;//Int最高楼层要求
@property(nonatomic,strong) RENumberItem *requirement_room_from;//Int最少卧室数量 要求
@property(nonatomic,strong) RENumberItem *requirement_room_to;//Int最大卧室数量 要求
@property(nonatomic,strong) RENumberItem *requirement_hall_from;//Int最少厅数量要 求
@property(nonatomic,strong) RENumberItem *requirement_hall_to;//Int最大厅数量要 求
@property(nonatomic,strong) RENumberItem *requirement_area_from;//最小面积要求
@property(nonatomic,strong) RENumberItem *requirement_area_to;//String最大面积要求
@property(nonatomic,strong) RERadioItem *requirement_client_source;//String客户来源


@property(nonatomic,strong) RERadioItem *business_requirement_type;//求租或求购
@property(nonatomic,strong) RENumberItem *requirement_sale_price_from;//String//￼最低求购价格
@property(nonatomic,strong) RENumberItem *requirement_sale_price_to;//最高求购价格
@property(nonatomic,strong) RERadioItem *sale_price_unit;//求购价格单位
@property(nonatomic,strong) RENumberItem *requirement_lease_price_from;//最低求租价格
@property(nonatomic,strong) RENumberItem *requirement_lease_price_to;//最高求租价格
@property(nonatomic,strong) RERadioItem *lease_price_unit;//求租价格单位

@property(nonatomic,strong) RETextItem *requirement_memo;//备注

@property(nonatomic,strong) RERadioItem *name_full;//置业顾问名字


@property(strong, readwrite, nonatomic) NSArray* tene_application_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* tene_type_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* fitment_type_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* house_driect_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* use_situation_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* client_source_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* look_permit_dic_arr;

@property(strong, readwrite, nonatomic) NSArray* shop_rank_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* office_rank_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* carport_rank_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* sex_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* requirementDictList;
@property(strong, readwrite, nonatomic) NSArray* client_level_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* client_type_dic_arr;
@property(strong, readwrite, nonatomic) NSArray *areaDictList;
@end
