//
//  HouseParticularTableViewController.m
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseParticularTableViewController.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "FollowTableViewController.h"
#import "AppointTableViewController.h"
#import "ContractTableViewController.h"
#import "SignAddController.h"
#import <objc/runtime.h>
#import "dictionaryManager.h"
#import "Macro.h"


@interface HouseParticularTableViewController ()


@property(strong, readwrite, nonatomic) NSArray* tene_application_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* tene_type_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* fitment_type_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* house_driect_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* use_situation_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* client_source_dic_arr;
@property(strong, readwrite, nonatomic) NSArray* look_permit_dic_arr;



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

@property (strong, readwrite, nonatomic) RERadioItem * owner_staff_name;
//String
//经纪人姓名

@property (strong, readwrite, nonatomic) RERadioItem * owner_staff_dept;
//String
//经纪人所属部门

@property (strong, readwrite, nonatomic) RERadioItem * owner_company_no;
//String
//经纪人所属公司编号

@property (strong, readwrite, nonatomic) RERadioItem * owner_compony_name;
//String
//经纪人所属公司名称

@property (strong, readwrite, nonatomic) RERadioItem * owner_mobile;
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


@property (strong, readwrite, nonatomic) RERadioItem * house_rank;
// String
// 如果是
// 商铺，商住，厂房，仓库，地皮表示位置:值取字典表中的

@property (strong, readwrite, nonatomic) RERadioItem * shop_rank;
//
// 车位表示车位类型：

@property (strong, readwrite, nonatomic) RERadioItem * carpot_rank;

// 写字楼表示级别:
@property (strong, readwrite, nonatomic) RERadioItem * office_rank;


@property (strong, readwrite, nonatomic) RERadioItem * house_depth;
// Float
// 进深

@property (strong, readwrite, nonatomic) RERadioItem * floor_height;
// Float
// 层高

@property (strong, readwrite, nonatomic) RERadioItem * floor_count;
// int
// 层数(里面有几层)

@property (strong, readwrite, nonatomic) RERadioItem * efficiency_rate;
// float
// 实用率(百分比)

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

@property(nonatomic,strong)RENumberItem* buildname;
//栋座（房源的）
//Int



@property(nonatomic,strong)RETableViewItem* client_secret_remark;
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

@end

@implementation HouseParticularTableViewController
@synthesize houseDtl;
@synthesize housePtcl;
@synthesize houseSecretPtcl;
@synthesize mode;


#pragma mark ---------------viewDidLoad----------------
#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.houseImageCtrl = [[houseImagesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    [self createSections];
    [self initDic];
    
    [self getData];
}
#pragma mark ---------------viewDidLoad----------------
#pragma mark


-(void)initDic
{
    self.tene_application_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_APPLICATION];
    self.tene_type_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_TYPE];
    self.fitment_type_dic_arr = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.house_driect_dic_arr = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
    self.use_situation_dic_arr = [dictionaryManager getItemArrByType:DIC_USE_SITUATION_TYPE];
    self.client_source_dic_arr = [dictionaryManager getItemArrByType:DIC_CLIENT_SOURCE_TYPE];
    self.look_permit_dic_arr = [dictionaryManager getItemArrByType:DIC_LOOK_PERMIT_TYPE];
}

-(NSArray*)getEditAbleFields
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.editFieldsArr = @[
                               @"hall_num",
                               @"room",
                               @"kitchen_num",
                               @"toilet_n",
                               @"balcony_num",
                               @"house_driect",
                               @"fitment_type",
                               @"build_year",
                               @"build_property",
                               @"use_situation",
                               @"build_structure_area",
                               @"client_name",
                               @"obj_mobile",
                               @"client_gender",
                               @"obj_fixtel",
                               @"client_identity",
                               @"obj_address",
                               @"client_remark",
                               @"b_staff_describ",
                               @"look_permit",
                               @"client_source",
                               @"house_rank",
                               @"house_depth",
                               @"floor_height",
                               @"floor_count",
                               @"efficiency_rate"
                               ];
    });
    
    return self.editFieldsArr;
}

-(void)reloadUI
{
    [self prepareSections];
    [self prepareItems];
    [self.tableView reloadData];
}

-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.infoSection];
    [self.manager addSection:self.secretSection];
    [self.manager addSection:self.actionSection];
}

-(void)prepareItems
{
    [self prepareInfoSectionItems];
    [self prepareSecretSectionItems];
    [self prepareActionSectionsItems];
}

-(void)prepareInfoSectionItems
{
    [self createInfoSectionItems];
    [self.infoSection addItem:self.watchHouseImages];
    
    //    @property (strong, readwrite, nonatomic) RETextItem * buildings_name;
    //    //String
    //    //楼盘名称
    [self.infoSection addItem:self.buildings_name];
    //    @property (strong, readwrite, nonatomic) RETextItem * urbanname;
    //    //String
    //    //区域
    [self.infoSection addItem:self.urbanname];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * areaname;
    //    //String
    //    //片区
    [self.infoSection addItem:self.areaname];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem *buildings_address;
    //    //String
    //    //地址
    [self.infoSection addItem:self.buildings_address];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * build_structure_area;
    //    //float
    //    //面积
    [self.infoSection addItem:self.build_structure_area];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_model_type;
    //    //户型
    //    //比如几室内几厅
    [self.infoSection addItem:self.house_model_type];
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * tene_application;
    //    //Int
    //    //物业用途（用来区分是住宅还是车位等）
    //    //不同的物业用途有不同的属性字段，详见其他说明
    [self.infoSection addItem:self.tene_application];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * tene_type;
    //    //Int
    //    //物业类型
    [self.infoSection addItem:self.tene_type];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
    //    //Int
    //    //装修
    [self.infoSection addItem:self.fitment_type];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * house_driect;
    //    //Int
    //    //朝向
    [self.infoSection addItem:self.house_driect];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
    //    //String
    //    //电梯（如奥旳斯
    [self.infoSection addItem:self.cons_elevator_brand];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
    //    //String
    //    //暖气
    [self.infoSection addItem:self.facility_heating];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
    //    //String
    //    //燃气
    [self.infoSection addItem:self.facility_gas];
    
    //
    //    @property (strong, readwrite, nonatomic) REDateTimeItem * build_year;
    //    //Int
    //    //建房年代
    [self.infoSection addItem:self.build_year];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * build_property;
    //    //Int
    //    //产权年限
    [self.infoSection addItem:self.build_property];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
    //    //Int
    //    //现状
    [self.infoSection addItem:self.use_situation];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
    //    //在第几层，共几层
    [self.infoSection addItem:self.house_and_build_floor];
    
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_total;
    //    //Float
    //    //总价(出售 万)
    [self.infoSection addItem:self.sale_value_total];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_single;
    //    //Float
    //    //单价(出售 元/平米)
    //todo 处理出租还是出售
    [self.infoSection addItem:self.sale_value_single];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * value_bottom;
    //    //Float
    //    //底价（出售 万）
    //todo 处理出租还是出售
    [self.infoSection addItem:self.value_bottom];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_total;
    //    //Float
    //    //总价(出租 元/月)
    //todo 处理出租还是出售
    [self.infoSection addItem:self.lease_value_total];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
    //    //Float
    //    //单价(出租 元/月/平米)
    //todo 处理出租还是出售
    [self.infoSection addItem:self.lease_value_single];

    //
    //    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
    //    //String
    //    //备注
    [self.infoSection addItem:self.client_remark];
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
    //    //String
    //    //房源描述
    [self.infoSection addItem:self.b_staff_describ];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * owner_staff_name;
    //    //String
    //    //经纪人姓名
    [self.infoSection addItem:self.owner_staff_name];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * owner_staff_dept;
    //    //String
    //    //经纪人所属部门
    [self.infoSection addItem:self.owner_staff_dept];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * owner_company_no;
    //    //String
    //    //经纪人所属公司编号
    [self.infoSection addItem:self.owner_company_no];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * owner_compony_name;
    //    //String
    //    //经纪人所属公司名称
    [self.infoSection addItem:self.owner_compony_name];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * owner_mobile;
    //    //String
    //    //经纪人电话
    [self.infoSection addItem:self.owner_mobile];
    
    //
    //    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
    //    //String
    //    //信息来源
    [self.infoSection addItem:self.client_source];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
    //String
    //看房:
    //预约
    //有钥匙
    //借钥匙
    //直接
    [self.infoSection addItem:self.look_permit];

    //@property (strong, readwrite, nonatomic) RERadioItem * sale_trade_state;
    //
    //
    // String
    // 状态（出售）
   [self.infoSection addItem:self.sale_trade_state];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * lease_trade_state;
    //
    // String
    // 状态（出租）
    [self.infoSection addItem:self.lease_trade_state];
    
    if (self.housePtcl)
    {
        if ([self.housePtcl.trade_type isEqualToString:@"出售"])
        {
            [self.infoSection removeItem:self.lease_trade_state];
            [self.infoSection removeItem:self.lease_value_total];
            [self.infoSection removeItem:self.lease_value_single];
        }
        else if ([self.housePtcl.trade_type isEqualToString:@"出租"])
        {
            [self.infoSection removeItem:self.sale_trade_state];
            [self.infoSection removeItem:self.sale_value_total];
            [self.infoSection removeItem:self.sale_value_single];
        }
    }
}

-(void)prepareSecretSectionItems
{
    [self createSecretSectionItems];
    [self.secretSection removeAllItems];
    [self.secretSection addItem:self.lookSecretItem];
}

-(void)prepareActionSectionsItems
{
    [self createActionSectionItems];
    [self.actionSection removeAllItems];
    [self.actionSection addItem:self.addGenJinActions];
    [self.actionSection addItem:self.addDaiKanActions];
    [self.actionSection addItem:self.addWeiTuoActions];
    [self.actionSection addItem:self.addQianYueActions];
}


#pragma mark ---------------getData----------------
#pragma mark
-(void)getData
{
    SHOWHUD_WINDOW;
    [HouseDataPuller pullHouseParticulars:self.houseDtl Success:^(HouseParticulars*ptcl)
     {
         self.housePtcl = ptcl;
         self.houseImageCtrl.housePtcl = ptcl;
         self.houseImageCtrl.houseDtl = self.houseDtl;
         [self reloadUI];
         
         HIDEHUD_WINDOW;
     }failure:^(NSError* error)
     {
         HIDEHUD_WINDOW;
     }];

}
#pragma mark ---------------getData----------------
#pragma mark


#pragma mark ---------------createSections----------------
#pragma mark
-(void)createSections
{
    CGFloat sectH = 22;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@"地区和位置信息"];
    self.addInfoSection.headerHeight = sectH;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@"基本信息"];
    self.infoSection.headerHeight = sectH;
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@"保密信息"];
    self.secretSection.headerHeight = sectH;
    self.actionSection = [RETableViewSection sectionWithHeaderTitle:@"相关操作"];
    self.actionSection.headerHeight = sectH;
}
#pragma mark ---------------createSections----------------
#pragma mark

#pragma mark ---------------createAddInfoSectionItems----------------
#pragma mark
-(void)createAddInfoSectionItems
{
    NSString*value = @"";
    __typeof (&*self) __weak weakSelf = self;
    
    //@property(strong,nonatomic)RERadioItem* builds_dict_no;
    //楼盘编号
    self.builds_dict_no = [[RERadioItem alloc] initWithTitle:@"楼盘编号:" value:value selectionHandler:^(RERadioItem *item)
    {
        //todo
    }];
    
    //@property(strong,nonatomic)RERadioItem* house_dict_no;
    //栋座编号
    self.house_dict_no = [[RERadioItem alloc] initWithTitle:@"栋座编号:" value:value selectionHandler:^(RERadioItem *item)
                           {
                               //todo
                           }];
    
    //@property(strong,nonatomic)RERadioItem* house_unit;
    //单元号
    value = @"";
    if (houseSecretPtcl)
    {
        value = houseSecretPtcl.house_unit;
    }
    self.house_unit = [[RERadioItem alloc] initWithTitle:@"单元号:" value:value selectionHandler:^(RERadioItem *item)
                          {
                              //todo
                          }];
    
    //@property(strong,nonatomic)RERadioItem* house_floor;
    //楼层
    value = @"";
    if (housePtcl)
    {
        value = self.housePtcl.house_floor;
    }
    self.house_floor = [[RERadioItem alloc] initWithTitle:@"楼层:" value:value selectionHandler:^(RERadioItem *item)
                       {
                           //todo
                       }];
    
    //@property(strong,nonatomic)RETextItem* house_tablet;
    //门牌号
    value = @"";
    if (houseSecretPtcl)
    {
        value = houseSecretPtcl.house_tablet;
    }
    self.house_tablet = [[RETextItem alloc] initWithTitle:@"门牌号:" value:value];
    
    //@property(strong,nonatomic)RETableViewItem* judgementBtn;
    //判重按钮
    self.judgementBtn = [RETableViewItem itemWithTitle:@"判重" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 
                             }];
    self.addDaiKanActions.textAlignment = NSTextAlignmentCenter;
    
    //@property (strong, readwrite, nonatomic) RERadioItem * trade_type;
    //String
    //房源类型:比如出售 是”100”，出租 是”101”
    //租售 是"102"
    //(这里和跟进的对象状态有关
    // 出售：出售状态
    // 出租：出租状态
    // 租售：出售状态
    value = @"";
    if (housePtcl)
    {
        value = housePtcl.trade_type;
    }
    self.trade_type = [[RERadioItem alloc] initWithTitle:@"交易类型:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
}
#pragma mark ---------------createAddInfoSectionItems----------------
#pragma mark

#pragma mark ---------------createInfoSectionItems----------------
#pragma mark
-(void)createInfoSectionItems
{
    NSString*value = @"";
    __typeof (&*self) __weak weakSelf = self;
    
    //图片
    [self createWatchImageBtn];
    
//    @property (strong, readwrite, nonatomic) RETextItem * buildings_name;
//    //String
//    //楼盘名称
    self.buildings_name = [[RETextItem alloc] initWithTitle:@"楼盘名称:" value:self.housePtcl.buildings_name];
    
//    @property (strong, readwrite, nonatomic) RETextItem * urbanname;
//    //String
//    //区域
    self.urbanname = [[RETextItem alloc] initWithTitle:@"区域:" value:self.housePtcl.urbanname];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem * areaname;
//    //String
//    //片区
    self.areaname = [[RETextItem alloc] initWithTitle:@"片区:" value:self.housePtcl.areaname];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem *buildings_address;
//    //String
//    //地址
    self.buildings_address = [[RETextItem alloc] initWithTitle:@"地址:" value:self.housePtcl.buildings_address];
    
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * build_structure_area;
//    //float
//    //面积
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@m²",self.housePtcl.build_structure_area];
    }
    self.build_structure_area = [[RENumberItem alloc] initWithTitle:@"面积:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_model_type;
//    //户型
//    //比如几室内几厅
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫%@阳台", self.housePtcl.room_num, self.housePtcl.hall_num, self.housePtcl.kitchen_num, self.housePtcl.toilet_num, self.housePtcl.balcony_num];
    }
    self.house_model_type = [[RETextItem alloc] initWithTitle:@"户型:" value:value];
//    
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * hall_num;
//    //Int
//    //房屋类型的厅的数量:如2厅
    self.hall_num = [[RENumberItem alloc] initWithTitle:@"室:" value:self.housePtcl.hall_num];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * room_num;
//    //Int
//    //房
    self.room_num = [[RENumberItem alloc] initWithTitle:@"房:" value:self.housePtcl.room_num];

//
//    @property (strong, readwrite, nonatomic) RENumberItem * kitchen_num;
//    //类型的
//    //的数量:如3室
//    //Int
//    //厨
    self.kitchen_num = [[RENumberItem alloc] initWithTitle:@"厨房:" value:self.housePtcl.kitchen_num];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * toilet_num;
//    //Int
//    //卫
    self.toilet_num = [[RENumberItem alloc] initWithTitle:@"卫生间:" value:self.housePtcl.toilet_num];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * balcony_num;
//    //In
//    //
//    //阳台
    self.balcony_num = [[RENumberItem alloc] initWithTitle:@"阳台:" value:self.housePtcl.balcony_num];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * tene_application;
//    //Int
//    //物业用途（用来区分是住宅还是车位等）
//    //不同的物业用途有不同的属性字段，详见其他说明
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.tene_application_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.tene_application])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.tene_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * tene_type;
//    //Int
//    //物业类型
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.tene_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.tene_type])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.tene_type = [[RERadioItem alloc] initWithTitle:@"物业类型:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
//    //Int
//    //装修
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.fitment_type_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.fitment_type])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.fitment_type = [[RERadioItem alloc] initWithTitle:@"装修:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * house_driect;
//    //Int
//    //朝向
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.house_driect_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.house_driect])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.house_driect = [[RERadioItem alloc] initWithTitle:@"朝向:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
//    //String
//    //电梯（如奥旳斯
    self.cons_elevator_brand = [[RETextItem alloc] initWithTitle:@"电梯:" value:self.housePtcl.cons_elevator_brand];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
//    //String
//    //暖气
    self.facility_heating = [[RETextItem alloc] initWithTitle:@"暖气:" value:self.housePtcl.facility_heating];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
//    //String
//    //燃气
    self.facility_gas = [[RETextItem alloc] initWithTitle:@"燃气:" value:self.housePtcl.facility_gas];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * build_year;
//    //Int
//    //建房年代
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.build_year;
    }
    self.build_year = [[RETextItem alloc] initWithTitle:@"建房年代:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * build_property;
//    //Int
//    //产权年限
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.build_property;
    }
    self.build_property = [[RENumberItem alloc] initWithTitle:@"产权年限:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
//    //Int
//    //现状
    
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.use_situation_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.use_situation])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.use_situation = [[RERadioItem alloc] initWithTitle:@"现状:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
//    //在第几层，共几层
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@层 共%@层",self.housePtcl.house_floor,self.housePtcl.build_floor_count];
    }
    self.house_and_build_floor = [[RETextItem alloc] initWithTitle:@"所在楼层:" value:value];

//
//    @property (strong, readwrite, nonatomic) RENumberItem * house_floor;
//    //Int
//    //所在楼层
    //self.house_floor = [[RENumberItem alloc] initWithTitle:@"所在楼层:" value:self.housePtcl.house_floor];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * build_floor_count;
//    //Int
//    //总楼层
    //self.build_floor_count = [[RENumberItem alloc] initWithTitle:@"总楼层:" value:self.housePtcl.build_floor_count];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_total;
//    //Float
//    //总价(出售 万)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@万元",self.housePtcl.sale_value_total];
    }
    self.sale_value_total = [[RENumberItem alloc] initWithTitle:@"总价:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_single;
//    //Float
//    //单价(出售 元/平米)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@元",self.housePtcl.sale_value_single];
    }
    self.sale_value_single = [[RENumberItem alloc] initWithTitle:@"单价:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * value_bottom;
//    //Float
//    //底价（出售 万）
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@万元",self.housePtcl.value_bottom];
    }
    self.value_bottom = [[RENumberItem alloc] initWithTitle:@"底价:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_total;
//    //Float
//    //总价(出租 元/月)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@万元",self.housePtcl.lease_value_total];
    }
    self.lease_value_total = [[RENumberItem alloc] initWithTitle:@"总价:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
//    //Float
//    //单价(出租 元/月/平米)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@元",self.housePtcl.lease_value_single];
    }
    self.lease_value_single = [[RENumberItem alloc] initWithTitle:@"单价:" value:value];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
//    //String
//    //备注
    self.client_remark = [[RETextItem alloc] initWithTitle:@"备注:" value:self.housePtcl.client_remark];

//    
//    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
//    //String
//    //房源描述
    self.b_staff_describ = [[RETextItem alloc] initWithTitle:@"房源描述:" value:self.housePtcl.b_staff_describ];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_staff_name;
//    //String
//    //经纪人姓名
    self.owner_staff_name = [[RERadioItem alloc] initWithTitle:@"经纪人姓名:" value:self.housePtcl.owner_staff_name selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_staff_dept;
//    //String
//    //经纪人所属部门
    self.owner_staff_dept = [[RERadioItem alloc] initWithTitle:@"经纪人部门:" value:self.housePtcl.owner_staff_dept selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_company_no;
//    //String
//    //经纪人所属公司编号
    self.owner_company_no = [[RERadioItem alloc] initWithTitle:@"经纪人公司编号:" value:self.housePtcl.owner_company_no selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_compony_name;
//    //String
//    //经纪人所属公司名称
    self.owner_compony_name = [[RERadioItem alloc] initWithTitle:@"经纪人公司名称:" value:self.housePtcl.owner_compony_name selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_mobile;
//    //String
//    //经纪人电话
    self.owner_mobile = [[RERadioItem alloc] initWithTitle:@"经纪人电话:" value:self.housePtcl.owner_mobile selectionHandler:^(RERadioItem *item) {
        //todo
    }];

//    
//    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
//    //String
//    //信息来源
    
    
    
    
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.client_source_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.client_source])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.client_source = [[RERadioItem alloc] initWithTitle:@"信息来源:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];

    
    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
    //String
    //看房:
    //预约
    //有钥匙
    //借钥匙
    //直接
    value = @"";
    if (self.housePtcl)
    {
        for (DicItem *di in self.look_permit_dic_arr)
        {
            if ([di.dict_value isEqualToString:self.housePtcl.look_permit])
            {
                value = di.dict_label;
                break;
            }
        }
    }
    self.look_permit = [[RERadioItem alloc] initWithTitle:@"看房:" value:value selectionHandler:^(RERadioItem *item) {
        //todo
    }];

    //@property (strong, readwrite, nonatomic) RERadioItem * sale_trade_state;
    //
    //
    // String
    // 状态（出售）
    self.sale_trade_state = [[RERadioItem alloc] initWithTitle:@"状态:" value:self.housePtcl.sale_trade_state selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * lease_trade_state;
    //
    // String
    // 状态（出租）
    self.lease_trade_state = [[RERadioItem alloc] initWithTitle:@"状态:" value:self.housePtcl.lease_trade_state selectionHandler:^(RERadioItem *item) {
        //todo
    }];
}

#pragma mark ---------------createInfoSectionItems----------------
#pragma mark

-(void)createSecretSectionItems
{
    [self createLookSecretBtn];
    
    //@property(nonatomic,strong)RETableViewItem* client_name;
    //业主（姓名）
    //String
    self.client_name = [[RETextItem alloc] initWithTitle:@"业主姓名:" value:self.houseSecretPtcl.client_name];
    [self.secretSection addItem:self.client_name];
    
    
    //@property(nonatomic,strong)RETableViewItem* obj_mobile;
    //手机号码（业主）
    //String
    self.obj_mobile = [[RENumberItem alloc] initWithTitle:@"手机号码:" value:self.houseSecretPtcl.obj_mobile];
    [self.secretSection addItem:self.obj_mobile];
    
    //@property(nonatomic,strong)RETableViewItem* client_gender;
    //性别（业主）
    //String
    self.sale_trade_state = [[RERadioItem alloc] initWithTitle:@"状态:" value:self.housePtcl.sale_trade_state selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    
    //@property(nonatomic,strong)RETableViewItem* obj_fixtel;
    //固定电话（业主）
    //String
    
    //@property(nonatomic,strong)RETableViewItem* client_identity;
    //身份证号（业主）
    //String
    
    //@property(nonatomic,strong)RETableViewItem* obj_address;
    //联系地址（业主）
    //String
    
    //@property(nonatomic,strong)RETableViewItem* buildname;
    //栋座（房源的）
    //Int
    
    //@property(nonatomic,strong)RETableViewItem* house_unit;
    //单元（房源的）
    //Int
    
    //@property(nonatomic,strong)RETableViewItem* house_tablet;
    //门牌号（房
    //的）
    //Int
    
    //@property(nonatomic,strong)RETableViewItem* client_secret_remark;
    //备注
    //String

    
}

-(void)createActionSectionItems
{
    [self createDaiKanBtn];
    [self createGenjinBtn];
    [self createWeiTuoBtn];
    [self createQianYueBtn];
}


-(void)adjustForMode
{
    if (mode == PAICULARMODE_READ)
    {
        [self.infoSection removeItem:self.room_num];
        [self.infoSection removeItem:self.hall_num];
        [self.infoSection removeItem:self.kitchen_num];
        [self.infoSection removeItem:self.toilet_num];
        [self.infoSection removeItem:self.balcony_num];
        [self.infoSection removeItem:self.house_floor];
        [self.infoSection removeItem:self.build_floor_count];
    }
}

-(void)adjustForTradeType
{
    if ([self.housePtcl.trade_type isEqualToString:@"出售"])
    {
        [self.infoSection removeItem:self.lease_trade_state];
    }
    else if ([self.housePtcl.trade_type isEqualToString:@"出租"])
    {
        [self.infoSection removeItem:self.sale_trade_state];
    }
    else if ([self.housePtcl.trade_type isEqualToString:@"租售"])
    {
        
    }
}




- (void)createWatchImageBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.watchHouseImages = [RETableViewItem itemWithTitle:@"点击查看图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                   {
                                       
                                       [weakSelf.navigationController pushViewController:self.houseImageCtrl animated:YES];
                                   }];
    self.watchHouseImages.textAlignment = NSTextAlignmentCenter;
}
- (void)createLookSecretBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.lookSecretItem = [RETableViewItem itemWithTitle:@"查看保密信息" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            
                        }];
    self.lookSecretItem.textAlignment = NSTextAlignmentCenter;
}
- (void)createGenjinBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addGenJinActions = [RETableViewItem itemWithTitle:@"跟进" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            FollowTableViewController *vc = [[FollowTableViewController alloc] initWithNibName:@"FollowTableViewController" bundle:[NSBundle mainBundle]];
                            vc.sid = self.houseDtl.house_trade_no;
                            vc.type = self.housePtcl.trade_type;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
    self.addGenJinActions.textAlignment = NSTextAlignmentCenter;
}
- (void)createDaiKanBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addDaiKanActions = [RETableViewItem itemWithTitle:@"带看" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            AppointTableViewController *vc = [[AppointTableViewController alloc] initWithNibName:@"AppointTableViewController" bundle:[NSBundle mainBundle]];
                            vc.sid = self.houseDtl.house_trade_no;
                            vc.type = self.housePtcl.trade_type;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
    self.addDaiKanActions.textAlignment = NSTextAlignmentCenter;
}
- (void)createWeiTuoBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addWeiTuoActions = [RETableViewItem itemWithTitle:@"委托" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            ContractTableViewController *vc = [[ContractTableViewController alloc] initWithNibName:@"ContractTableViewController" bundle:[NSBundle mainBundle]];
                            vc.sid = self.houseDtl.house_trade_no;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
    self.addWeiTuoActions.textAlignment = NSTextAlignmentCenter;
}

- (void)createQianYueBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addQianYueActions = [RETableViewItem itemWithTitle:@"签约" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            SignAddController *vc = [[SignAddController alloc] initWithStyle:UITableViewStyleGrouped];
                            vc.sid = self.houseDtl.house_trade_no;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
    self.addQianYueActions.textAlignment = NSTextAlignmentCenter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
