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
#import <objc/runtime.h>


@interface HouseParticularTableViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *infoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *secretSection;

//小区图,户型图,室内图,
@property (strong, readwrite, nonatomic) RETableViewItem * houseImages;
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

@property (strong, readwrite, nonatomic) RETextItem * tene_application;
//Int
//物业用途（用来区分是住宅还是车位等）
//不同的物业用途有不同的属性字段，详见其他说明

@property (strong, readwrite, nonatomic) RETextItem * tene_type;
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
//电梯（如奥旳斯

@property (strong, readwrite, nonatomic) RETextItem * facility_heating;
//String
//暖气

@property (strong, readwrite, nonatomic) RETextItem * facility_gas;
//String
//燃气

@property (strong, readwrite, nonatomic) REDateTimeItem * build_year;
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

@property (strong, readwrite, nonatomic) RENumberItem * house_floor;
//Int
//所在楼层

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

//@property (strong, readwrite, nonatomic) RERadioItem * edit_permit;
//String
//是否有编辑权限
//0=无
//1=有
//如果有编辑权限就有查看保密信息的权限

//@property (strong, readwrite, nonatomic) RERadioItem * secret_permit;
////String
////是
//
//@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
//有查看保密信息的权限
//String
//看房:
//预约
//有钥匙
//借钥匙
//直接

@property (strong, readwrite, nonatomic) RERadioItem * xqt;
//String
//主图

@property (strong, readwrite, nonatomic) RERadioItem * hxt;
//String
//户型图

@property (strong, readwrite, nonatomic) RERadioItem * snt;
//String
//室内图

@property (strong, readwrite, nonatomic) RERadioItem * trade_type;
//String
//房源类型:比如出售 是”100”，出租 是”101”
//租售 是"102"
//(这里和跟进的对象状态有关
// 出售：出售状态
// 出租：出租状态
// 租售：出售状态

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

@property (strong, readwrite, nonatomic) RERadioItem * buildings_picture;
// String
// 房源图片ID


@property (strong, readwrite, nonatomic) RETableViewItem * lookSecretItem;
// 查看保密信息

@property (strong, readwrite, nonatomic) RETableViewItem * addGenJinActions;
//4个按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addDaiKanActions;
//4个按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addWeiTuoActions;
//4个按钮
@property (strong, readwrite, nonatomic) RETableViewItem * addQianYueActions;
//4个按钮


@end

@implementation HouseParticularTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    self.houseImageCtrl = [[houseImagesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    //[self loadDataToUI];
    
    [self getData];
}


-(void)getData
{
    SHOWHUD_WINDOW;
    [HouseDataPuller pullHouseParticulars:self.houseDtl Success:^(HouseParticulars*ptcl)
     {
         self.housePtcl = ptcl;
         self.houseImageCtrl.housePtcl = ptcl;
         self.houseImageCtrl.houseDtl = self.houseDtl;
         [self loadDataToUI];
         [self.tableView reloadData];
         HIDEHUD_WINDOW;
     }failure:^(NSError* error)
     {
         HIDEHUD_WINDOW;
     }];

}

-(void)createInfoSection
{
    __typeof (&*self) __weak weakSelf = self;
    
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:self.infoSection];
    
    //图片
    [self addWatchImageBtn];
    
//    @property (strong, readwrite, nonatomic) RETextItem * buildings_name;
//    //String
//    //楼盘名称
    self.buildings_name = [[RETextItem alloc] initWithTitle:@"楼盘名称:" value:self.housePtcl.buildings_name];
    [self.infoSection addItem:self.buildings_name];
    self.buildings_name.enabled = NO;
    
//    @property (strong, readwrite, nonatomic) RETextItem * urbanname;
//    //String
//    //区域
    self.urbanname = [[RETextItem alloc] initWithTitle:@"区域:" value:self.housePtcl.urbanname];
    [self.infoSection addItem:self.urbanname];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem * areaname;
//    //String
//    //片区
    self.areaname = [[RETextItem alloc] initWithTitle:@"片区:" value:self.housePtcl.areaname];
    [self.infoSection addItem:self.areaname];
    
//    
//    @property (strong, readwrite, nonatomic) RETextItem *buildings_address;
//    //String
//    //地址
    self.buildings_address = [[RETextItem alloc] initWithTitle:@"地址:" value:self.housePtcl.buildings_address];
    [self.infoSection addItem:self.buildings_address];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * build_structure_area;
//    //float
//    //面积
    self.build_structure_area = [[RENumberItem alloc] initWithTitle:@"面积:" value:self.housePtcl.build_structure_area];
    [self.infoSection addItem:self.build_structure_area];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_model_type;
//    //户型
//    //比如几室内几厅
    NSString*tmp = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫%@阳台", self.housePtcl.room_num, self.housePtcl.hall_num, self.housePtcl.kitchen_num, self.housePtcl.toilet_num, self.housePtcl.balcony_num];
    self.house_model_type = [[RETextItem alloc] initWithTitle:@"户型:" value:tmp];
    [self.infoSection addItem:self.house_model_type];
//    
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * hall_num;
//    //Int
//    //房屋类型的厅的数量:如2厅
    self.hall_num = [[RENumberItem alloc] initWithTitle:@"室:" value:self.housePtcl.hall_num];
    [self.infoSection addItem:self.hall_num];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * room_num;
//    //Int
//    //房
    self.room_num = [[RENumberItem alloc] initWithTitle:@"房:" value:self.housePtcl.room_num];
    [self.infoSection addItem:self.room_num];
//
//    @property (strong, readwrite, nonatomic) RENumberItem * kitchen_num;
//    //类型的
//    //的数量:如3室
//    //Int
//    //厨
    self.kitchen_num = [[RENumberItem alloc] initWithTitle:@"厨房:" value:self.housePtcl.kitchen_num];
    [self.infoSection addItem:self.kitchen_num];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * toilet_num;
//    //Int
//    //卫
    self.toilet_num = [[RENumberItem alloc] initWithTitle:@"卫生间:" value:self.housePtcl.toilet_num];
    [self.infoSection addItem:self.toilet_num];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * balcony_num;
//    //In
//    //
//    //阳台
    self.balcony_num = [[RENumberItem alloc] initWithTitle:@"阳台:" value:self.housePtcl.balcony_num];
    [self.infoSection addItem:self.balcony_num];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * tene_application;
//    //Int
//    //物业用途（用来区分是住宅还是车位等）
//    //不同的物业用途有不同的属性字段，详见其他说明
    self.tene_application = [[RETextItem alloc] initWithTitle:@"物业用途:" value:self.housePtcl.tene_application];
    [self.infoSection addItem:self.tene_application];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * tene_type;
//    //Int
//    //物业类型
    self.tene_type = [[RETextItem alloc] initWithTitle:@"物业类型:" value:self.housePtcl.tene_type];
    [self.infoSection addItem:self.tene_type];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
//    //Int
//    //装修
    self.fitment_type = [[RERadioItem alloc] initWithTitle:@"装修:" value:self.housePtcl.fitment_type selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.fitment_type];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * house_driect;
//    //Int
//    //朝向
    self.house_driect = [[RERadioItem alloc] initWithTitle:@"朝向:" value:self.housePtcl.house_driect selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.house_driect];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
//    //String
//    //电梯（如奥旳斯
    self.cons_elevator_brand = [[RETextItem alloc] initWithTitle:@"电梯:" value:self.housePtcl.cons_elevator_brand];
    [self.infoSection addItem:self.cons_elevator_brand];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
//    //String
//    //暖气
    self.facility_heating = [[RETextItem alloc] initWithTitle:@"暖气:" value:self.housePtcl.facility_heating];
    [self.infoSection addItem:self.facility_heating];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
//    //String
//    //燃气
    self.facility_gas = [[RETextItem alloc] initWithTitle:@"暖气:" value:self.housePtcl.facility_gas];
    [self.infoSection addItem:self.facility_gas];
//    
//    @property (strong, readwrite, nonatomic) REDateTimeItem * build_year;
//    //Int
//    //建房年代
    self.build_year = [[REDateTimeItem alloc] initWithTitle:@"建房年代:" value:[NSDate new] placeholder:@"" format:@"xxxx" datePickerMode:UIDatePickerModeTime];
    [self.infoSection addItem:self.build_year];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * build_property;
//    //Int
//    //产权年限
    self.build_property = [[RENumberItem alloc] initWithTitle:@"产权年限:" value:self.housePtcl.build_property];
    [self.infoSection addItem:self.build_property];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
//    //Int
//    //现状
    self.use_situation = [[RERadioItem alloc] initWithTitle:@"现状:" value:self.housePtcl.use_situation selectionHandler:^(RERadioItem *item) {
        //todo
    }];
     [self.infoSection addItem:self.use_situation];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
//    //在第几层，共几层
    //TODO
    self.house_and_build_floor = [[RETextItem alloc] initWithTitle:@"所在楼层:" value:self.housePtcl.house_floor];
    [self.infoSection addItem:self.house_and_build_floor];
//
//    @property (strong, readwrite, nonatomic) RENumberItem * house_floor;
//    //Int
//    //所在楼层
    self.house_floor = [[RENumberItem alloc] initWithTitle:@"所在楼层:" value:self.housePtcl.house_floor];
    [self.infoSection addItem:self.house_floor];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * build_floor_count;
//    //Int
//    //总楼层
    self.build_floor_count = [[RENumberItem alloc] initWithTitle:@"总楼层:" value:self.housePtcl.build_floor_count];
    [self.infoSection addItem:self.build_floor_count];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_total;
//    //Float
//    //总价(出售 万)
    //todo 处理出租还是出售
    self.sale_value_total = [[RENumberItem alloc] initWithTitle:@"总价:" value:self.housePtcl.sale_value_total];
    [self.infoSection addItem:self.sale_value_total];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_single;
//    //Float
//    //单价(出售 元/平米)
    //todo 处理出租还是出售
    self.sale_value_single = [[RENumberItem alloc] initWithTitle:@"单价:" value:self.housePtcl.sale_value_single];
    [self.infoSection addItem:self.sale_value_single];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * value_bottom;
//    //Float
//    //底价（出售 万）
    //todo 处理出租还是出售
    self.value_bottom = [[RENumberItem alloc] initWithTitle:@"单价:" value:self.housePtcl.value_bottom];
    [self.infoSection addItem:self.value_bottom];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_total;
//    //Float
//    //总价(出租 元/月)
    //todo 处理出租还是出售
    self.lease_value_total = [[RENumberItem alloc] initWithTitle:@"总价:" value:self.housePtcl.lease_value_total];
    [self.infoSection addItem:self.lease_value_total];
//    
//    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
//    //Float
//    //单价(出租 元/月/平米)
    //todo 处理出租还是出售
    self.lease_value_single = [[RENumberItem alloc] initWithTitle:@"单价:" value:self.housePtcl.lease_value_single];
    [self.infoSection addItem:self.lease_value_single];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
//    //String
//    //备注
    self.client_remark = [[RETextItem alloc] initWithTitle:@"备注:" value:self.housePtcl.client_remark];
    [self.infoSection addItem:self.client_remark];
//    
//    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
//    //String
//    //房源描述
    self.b_staff_describ = [[RETextItem alloc] initWithTitle:@"房源描述:" value:self.housePtcl.b_staff_describ];
    [self.infoSection addItem:self.b_staff_describ];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_staff_name;
//    //String
//    //经纪人姓名
    self.owner_staff_name = [[RERadioItem alloc] initWithTitle:@"经纪人姓名:" value:self.housePtcl.owner_staff_name selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.owner_staff_name];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_staff_dept;
//    //String
//    //经纪人所属部门
    self.owner_staff_dept = [[RERadioItem alloc] initWithTitle:@"经纪人部门:" value:self.housePtcl.owner_staff_dept selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.owner_staff_dept];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_company_no;
//    //String
//    //经纪人所属公司编号
    self.owner_company_no = [[RERadioItem alloc] initWithTitle:@"经纪人公司编号:" value:self.housePtcl.owner_company_no selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.owner_company_no];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_compony_name;
//    //String
//    //经纪人所属公司名称
    self.owner_compony_name = [[RERadioItem alloc] initWithTitle:@"经纪人公司名称:" value:self.housePtcl.owner_compony_name selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.owner_compony_name];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * owner_mobile;
//    //String
//    //经纪人电话
    self.owner_mobile = [[RERadioItem alloc] initWithTitle:@"经纪人电话:" value:self.housePtcl.owner_mobile selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.owner_mobile];
//    
//    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
//    //String
//    //信息来源
    self.client_source = [[RERadioItem alloc] initWithTitle:@"信息来源:" value:self.housePtcl.client_source selectionHandler:^(RERadioItem *item) {
        //todo
    }];
    [self.infoSection addItem:self.client_source];
    
    
    [self addLookSecretBtn];
    [self addGenjinBtn];
    [self addDaiKanBtn];
    [self addWeiTuoBtn];
    [self addQianYueBtn];
    
}

-(void)createSecretInfoSection
{
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@""];
    
    
    [self.manager addSection:self.secretSection];
}


- (void)addWatchImageBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.houseImages = [RETableViewItem itemWithTitle:@"点击查看图片" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                   {
                                       
                                       [weakSelf.navigationController pushViewController:self.houseImageCtrl animated:YES];
                                   }];
    self.houseImages.textAlignment = NSTextAlignmentCenter;
    [self.infoSection addItem:self.houseImages];

}
- (void)addLookSecretBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.lookSecretItem = [RETableViewItem itemWithTitle:@"查看保密信息" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            
                        }];
    self.lookSecretItem.textAlignment = NSTextAlignmentCenter;
    [self.infoSection addItem:self.lookSecretItem];
    
}
- (void)addGenjinBtn
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
    [self.infoSection addItem:self.addGenJinActions];
    
}
- (void)addDaiKanBtn
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
    [self.infoSection addItem:self.addDaiKanActions];
    
}
- (void)addWeiTuoBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addWeiTuoActions = [RETableViewItem itemWithTitle:@"委托" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            ContractTableViewController *vc = [[ContractTableViewController alloc] initWithNibName:@"ContractTableViewController" bundle:[NSBundle mainBundle]];
                            vc.sid = self.houseDtl.house_trade_no;
                            vc.type = self.housePtcl.trade_type;
                            [weakSelf.navigationController pushViewController:vc animated:YES];

                        }];
    self.addWeiTuoActions.textAlignment = NSTextAlignmentCenter;
    [self.infoSection addItem:self.addWeiTuoActions];
    
}

- (void)addQianYueBtn
{
    __typeof (&*self) __weak weakSelf = self;
    self.addQianYueActions = [RETableViewItem itemWithTitle:@"签约" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                        {
                            
                        }];
    self.addQianYueActions.textAlignment = NSTextAlignmentCenter;
    [self.infoSection addItem:self.addQianYueActions];
    
}

-(void)loadDataToUI
{
    [self createInfoSection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
