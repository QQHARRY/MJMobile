//
//  HouseParticularTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"
#import "houseSecretParticulars.h"
#import "houseImagesTableViewController.h"


typedef NS_ENUM(NSInteger, PAICULARMODE) {
    PAICULARMODE_READ,
    PAICULARMODE_EDIT,
    PAICULARMODE_CREATE
};



@interface HouseParticularTableViewController : UITableViewController<RETableViewManagerDelegate>

@property(strong,nonatomic)HouseDetail*houseDtl;
@property(strong,nonatomic)HouseParticulars*housePtcl;
@property(strong,nonatomic)houseSecretParticulars*houseSecretPtcl;
@property(strong,nonatomic)NSArray*editFieldsArr;
@property(strong,nonatomic)houseImagesTableViewController*houseImageCtrl;


@property(assign,nonatomic)PAICULARMODE mode;

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
@property (strong, readwrite, nonatomic) RETableViewManager *manager;
#pragma mark ---------------sections----------------
#pragma mark
@property (strong, readwrite, nonatomic) RETableViewSection *addInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *infoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *secretSection;
@property (strong, readwrite, nonatomic) RETableViewSection *actionSection;
#pragma mark ---------------sections----------------
#pragma mark


#pragma mark ---------------addInfoSection items----------------
#pragma mark
@property(strong,nonatomic)RERadioItem* builds_dict_no;
//楼盘编号

@property(strong,nonatomic)RERadioItem* house_dict_no;
//栋座编号

@property(strong,nonatomic)RERadioItem* house_unit;
//单元号

@property(strong,nonatomic)RERadioItem* house_floor;
//楼层

@property(strong,nonatomic)RETextItem* house_tablet;
//门牌号

@property(strong,nonatomic)RERadioItem* trade_type;
//String
//房源类型:比如出售 是”100”，出租 是”101”
//租售 是"102"
//(这里和跟进的对象状态有关
// 出售：出售状态
// 出租：出租状态
// 租售：出售状态

@property(strong,nonatomic)RETableViewItem* judgementBtn;
//判重按钮

#pragma mark ---------------addInfoSection items----------------
#pragma mark



#pragma mark ---------------infoSection items----------------
#pragma mark

@property (strong, readwrite, nonatomic) RETableViewItem * watchHouseImages;
//点击进入查看:小区图,户型图,室内图

@property (strong, readwrite, nonatomic) RETextItem * buildings_name;
//String
//楼盘名称

@property (strong, readwrite, nonatomic) RETextItem * urbanname;
//String
//区域

@property (strong, readwrite, nonatomic) RETextItem * areaname;
//String
//片区

@property (strong, readwrite, nonatomic) RETextItem *buildings_address;
//String
//地址

@property (strong, readwrite, nonatomic) RENumberItem * build_structure_area;
//float
//面积

@property (strong, readwrite, nonatomic) RETextItem * house_model_type;
//户型
//比如几室内几厅


@property (strong, readwrite, nonatomic) RENumberItem * hall_num;
//Int
//房屋类型的厅的数量:如2厅

@property (strong, readwrite, nonatomic) RENumberItem * room_num;
//Int
//房

@property (strong, readwrite, nonatomic) RENumberItem * kitchen_num;
//类型的
//的数量:如3室
//Int
//厨

@property (strong, readwrite, nonatomic) RENumberItem * toilet_num;
//Int
//卫

@property (strong, readwrite, nonatomic) RENumberItem * balcony_num;
//In
//
//阳台

@property (strong, readwrite, nonatomic) RERadioItem * tene_application;
//Int
//物业用途（用来区分是住宅还是车位等）
//不同的物业用途有不同的属性字段，详见其他说明

@property (strong, readwrite, nonatomic) RERadioItem * house_rank;
// String
// 如果是
// 商铺，商住，厂房，仓库，地皮表示位置:值取字典表中的

//@property (strong, readwrite, nonatomic) RERadioItem * shop_rank;
//////
////// 车位表示车位类型：
////
//
//@property (strong, readwrite, nonatomic) RERadioItem * carpot_rank;
////
////// 写字楼表示级别:
//
//@property (strong, readwrite, nonatomic) RERadioItem * office_rank;


@property (strong, readwrite, nonatomic) RENumberItem * house_depth;
// Float
// 进深

@property (strong, readwrite, nonatomic) RENumberItem * floor_height;
// Float
// 层高

@property (strong, readwrite, nonatomic) RENumberItem * floor_count;
// int
// 层数(里面有几层)

@property (strong, readwrite, nonatomic) RENumberItem * efficiency_rate;
// float
// 实用率(百分比)

@property (strong, readwrite, nonatomic) RERadioItem * tene_type;
//Int
//物业类型

@property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
//Int
//装修

@property (strong, readwrite, nonatomic) RERadioItem * house_driect;
//Int
//朝向

@property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
//String
//电梯（如奥旳斯)

@property (strong, readwrite, nonatomic) RETextItem * facility_heating;
//String
//暖气

@property (strong, readwrite, nonatomic) RETextItem * facility_gas;
//String
//燃气

@property (strong, readwrite, nonatomic) RETextItem * build_year;
//Int
//建房年代

@property (strong, readwrite, nonatomic) RENumberItem * build_property;
//Int
//产权年限

@property (strong, readwrite, nonatomic) RERadioItem * use_situation;
//Int
//现状

@property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
//在第几层，共几层

@property (strong, readwrite, nonatomic) RENumberItem * build_floor_count;
//Int
//总楼层

@property (strong, readwrite, nonatomic) RENumberItem * sale_value_total;
//Float
//总价(出售 万)

@property (strong, readwrite, nonatomic) RENumberItem * sale_value_single;
//Float
//单价(出售 元/平米)

@property (strong, readwrite, nonatomic) RENumberItem * value_bottom;
//Float
//底价（出售 万）

@property (strong, readwrite, nonatomic) RENumberItem * lease_value_total;
//Float
//总价(出租 元/月)

@property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
//Float
//单价(出租 元/月/平米)

@property (strong, readwrite, nonatomic) RETextItem * client_remark;
//String
//备注

@property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
//String
//房源描述

@property (strong, readwrite, nonatomic) RETextItem * owner_staff_name;
//String
//经纪人姓名

@property (strong, readwrite, nonatomic) RETextItem * owner_staff_dept;
//String
//经纪人所属部门

@property (strong, readwrite, nonatomic) RETextItem * owner_company_no;
//String
//经纪人所属公司编号

@property (strong, readwrite, nonatomic) RETextItem * owner_compony_name;
//String
//经纪人所属公司名称

@property (strong, readwrite, nonatomic) RETextItem * owner_mobile;
//String
//经纪人电话

@property (strong, readwrite, nonatomic) RERadioItem * client_source;
//String
//信息来源

@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
//String
//看房:
//预约
//有钥匙
//借钥匙
//直接



@property (strong, readwrite, nonatomic) RERadioItem * sale_trade_state;
//出租状态）
//
// String
// 状态（出售）

@property (strong, readwrite, nonatomic) RERadioItem * lease_trade_state;
//
// String
// 状态（出租）


//@property (strong, readwrite, nonatomic) RERadioItem * buildings_picture;
//// String
//// 房源图片ID
#pragma mark ---------------infoSection items----------------
#pragma mark


#pragma mark ---------------secretSection items----------------
#pragma mark
@property (strong, readwrite, nonatomic) RETableViewItem * lookSecretItem;
//查看保密信息按钮

@property(nonatomic,strong)RETextItem* client_name;
//业主（姓名）
//String

@property(nonatomic,strong)RENumberItem* obj_mobile;
//手机号码（业主）
//String

@property(nonatomic,strong)RERadioItem* client_gender;
//性别（业主）
//String

@property(nonatomic,strong)RENumberItem* obj_fixtel;
//固定电话（业主）
//String

@property(nonatomic,strong)RETextItem* client_identity;
//身份证号（业主）
//String

@property(nonatomic,strong)RETextItem* obj_address;
//联系地址（业主）
//String

@property(nonatomic,strong)RERadioItem* buildname;
//栋座（房源的）
//Int

@property(nonatomic,strong)RERadioItem* house_serect_unit;
//house_unit
//单元（房源的）
//Int

@property(nonatomic,strong)RETextItem* house_secrect_tablet;
//house_tablet
//门牌号（房
//的）
//Int

@property(nonatomic,strong)RETextItem* client_secret_remark;
//备注
//String
#pragma mark ---------------secretSection items----------------
#pragma mark

#pragma mark ---------------actionSection items----------------
#pragma mark
@property (strong, readwrite, nonatomic) RETableViewItem * addGenJinActions;
//跟进按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addDaiKanActions;
//带看按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addWeiTuoActions;
//委托按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addQianYueActions;
//签约按钮
#pragma mark ---------------actionSection items----------------
#pragma mark
#pragma mark ---------------elementMethods----------------
#pragma mark
-(BOOL)isString:(NSString*)str InStringArr:(NSArray*)arr;
-(NSString*)nameOfInstance:(id)instance;
-(id)instanceOfName:(NSString*)name;

@property (assign,nonatomic)BOOL refreshAfterEdit;
-(void)setNeedRefresh;

-(void)prepareSections;
-(void)prepareItems;
-(void)prepareInfoSectionItems;
-(void)prepareSecretSectionItems;
-(void)prepareActionSectionsItems;
-(void)createSections;
-(void)createAddInfoSectionItems;
-(void)createInfoSectionItems;
-(void)createSecretSectionItems;
-(void)createActionSectionItems;
-(void)enableOrDisableItems;
-(void)adjustByTeneApplication;
-(void)adjustUI;
-(void)adjustByTradeType;
-(NSArray*)getEditAbleFields;
@end
