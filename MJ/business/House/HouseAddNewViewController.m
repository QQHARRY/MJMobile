//
//  HouseAddNewViewController.m
//  MJ
//
//  Created by harry on 15/1/14.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseAddNewViewController.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "BuildingsSelectTableViewController.h"
#import "dictionaryManager.h"
#import "HouseSelectBuildingTableViewController.h"
#import "HouseDataPuller.h"

@interface HouseAddNewViewController ()
@property(strong,readwrite,nonatomic)RETableViewSection*teneApplicationAbout;
@end

@implementation HouseAddNewViewController
@synthesize curBuildings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.curBuilidngsOfCurBuildings = [[NSMutableArray alloc] init];
    [self reloadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//cover the metod of super class
-(void)getData
{
}

-(void)reloadUI
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];
    
    [self prepareSections];
    [self prepareItems];
    [self.tableView reloadData];
}

-(void)createSections
{
    CGFloat sectH = 22;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.addInfoSection.headerHeight = sectH;
    self.teneApplicationAbout = [RETableViewSection sectionWithHeaderTitle:@""];
    self.teneApplicationAbout.headerHeight = 1;
    self.infoSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.infoSection.headerHeight = 1;
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.secretSection.headerHeight = 1;
    self.addInfoSection = [RETableViewSection sectionWithHeaderTitle:@""];
}

-(void)prepareSections
{
    [self.manager removeAllSections];
    [self.manager addSection:self.addInfoSection];
    [self.manager addSection:self.teneApplicationAbout];
    [self.manager addSection:self.infoSection];
    [self.manager addSection:self.secretSection];
    
}

-(void)prepareItems
{
    [self createSecretSectionItems];
    [self createAddInfoSectionItems];
    [self createInfoSectionItems];
    [self prepareAddInfoSectionItems];
}


-(void)setInfoSectionItemsValue
{
    NSString*title = @"";
    NSString*value = @"";
    __typeof (&*self) __weak weakSelf = self;
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * build_structure_area;
    //    //float
    //    //面积
    value = @"";
    if (self.housePtcl)
    {
        if(self.housePtcl.build_structure_area)
        {
            value = [NSString stringWithFormat:@"%@m²",self.housePtcl.build_structure_area];
            self.build_structure_area.value =value;
        }
        
    }
    
    //
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * hall_num;
    //    //Int
    //    //房屋类型的厅的数量:如2厅
    value = @"";
    if (self.housePtcl && self.housePtcl.hall_num)
    {
        value = self.housePtcl.hall_num;
         self.hall_num.value =value;
    }
   
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * room_num;
    //    //Int
    //    //房
    value = @"";
    if (self.housePtcl && self.housePtcl.room_num)
    {
        value = self.housePtcl.room_num;
        self.room_num.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * kitchen_num;
    //    //类型的
    //    //的数量:如3室
    //    //Int
    //    //厨
    value = @"";
    if (self.housePtcl && self.housePtcl.kitchen_num)
    {
        value = self.housePtcl.kitchen_num;
        self.kitchen_num.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * toilet_num;
    //    //Int
    //    //卫
    value = @"";
    if (self.housePtcl && self.housePtcl.toilet_num)
    {
        value = self.housePtcl.toilet_num;
        self.toilet_num.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * balcony_num;
    //    //In
    //    //
    //    //阳台
    value = @"";
    if (self.housePtcl && self.housePtcl.balcony_num)
    {
        value = self.housePtcl.balcony_num;
        self.balcony_num.value =value;
    }
    
    
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
                self.tene_application.value =value;
                break;
            }
        }
    }
    
    //@property (strong, readwrite, nonatomic) RERadioItem * house_rank;
    // String
    // 如果是
    // 商铺，商住，厂房，仓库，地皮表示位置:值取字典表中的
    title = @"";
    value = @"";
    
    if (self.housePtcl)
    {
        if ([self.tene_application.value isEqualToString:@"商铺"] ||
            [self.tene_application.value isEqualToString:@"商住"] ||
            [self.tene_application.value isEqualToString:@"厂房"] ||
            [self.tene_application.value isEqualToString:@"仓库"] ||
            [self.tene_application.value isEqualToString:@"地皮"]
            )
        {
            title = @"位置";
            
            for (DicItem *di in self.shop_rank_dic_arr)
            {
                if ([di.dict_value isEqualToString:self.housePtcl.house_rank])
                {
                    value = di.dict_label;
                    break;
                }
            }
        }
        else if ([self.tene_application.value isEqualToString:@"车位"])
        {
            title = @"车位类型";
            for (DicItem *di in self.carport_rank_dic_arr)
            {
                if ([di.dict_value isEqualToString:self.housePtcl.house_rank])
                {
                    value = di.dict_label;
                    break;
                }
            }
        }
        else if ([self.tene_application.value isEqualToString:@"写字楼"])
        {
            title = @"级别";
            for (DicItem *di in self.office_rank_dic_arr)
            {
                if ([di.dict_value isEqualToString:self.housePtcl.house_rank])
                {
                    value = di.dict_label;
                    break;
                }
            }
        }
    }
    if (![value isEqualToString:@""])
    {
        self.house_rank.value =value;
    }
    
    //@property (strong, readwrite, nonatomic) RERadioItem * carpot_rank;
    //
    //// 写字楼表示级别:
    //@property (strong, readwrite, nonatomic) RERadioItem * office_rank;
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * house_depth;
    // Float
    // 进深
    value = @"";
    if (self.housePtcl && self.housePtcl.house_depth)
    {
        value = self.housePtcl.house_depth;
        self.house_depth.value =value;
    }
    

    
    //@property (strong, readwrite, nonatomic) RERadioItem * floor_height;
    // Float
    // 层高
    value = @"";
    if (self.housePtcl && self.housePtcl.floor_height)
    {
        value = self.housePtcl.floor_height;
        self.floor_height.value =value;
    }
    

    
    //@property (strong, readwrite, nonatomic) RERadioItem * floor_count;
    // int
    // 层数(里面有几层)
    value = @"";
    if (self.housePtcl && self.housePtcl.floor_count)
    {
        value = self.housePtcl.floor_count;
        self.floor_count.value =value;
    }
    

    
    //@property (strong, readwrite, nonatomic) RERadioItem * efficiency_rate;
    // float
    // 实用率(百分比)
    value = @"";
    if (self.housePtcl && self.housePtcl.efficiency_rate)
    {
        value = self.housePtcl.efficiency_rate;
        self.efficiency_rate.value =value;
    }
    

   
    
    
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
                self.house_driect.value =value;
                break;
            }
        }
    }
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
    //    //String
    //    //电梯（如奥旳斯
    value = @"";
    if (self.housePtcl && self.housePtcl.cons_elevator_brand)
    {
        value = self.housePtcl.cons_elevator_brand;
        self.cons_elevator_brand.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
    //    //String
    //    //暖气
    value = @"";
    if (self.housePtcl && self.housePtcl.facility_heating)
    {
        value = self.housePtcl.facility_heating;
        self.facility_heating.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
    //    //String
    //    //燃气
    value = @"";
    if (self.housePtcl && self.housePtcl.facility_gas)
    {
        value = self.housePtcl.facility_gas;
        self.facility_gas.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * build_year;
    //    //Int
    //    //建房年代
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.build_year;
        self.build_year.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * build_property;
    //    //Int
    //    //产权年限
    value = @"";
    if (self.housePtcl)
    {
        value = self.housePtcl.build_property;
        self.build_property.value =value;
    }
    
    
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
                self.use_situation.value =value;
                break;
            }
        }
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * house_and_build_floor;
    //    //在第几层，共几层
    value = @"";
    if (self.housePtcl)
    {
        value = [NSString stringWithFormat:@"%@层 共%@层",self.housePtcl.house_floor,self.housePtcl.build_floor_count];
        self.house_and_build_floor.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * house_floor;
    //    //Int
    //    //所在楼层
    //self.house_floor = [[RENumberItem alloc] initWithTitle:@"所在楼层:" value:self.housePtcl.house_floor];
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * build_floor_count;
    //    //Int
    //    //总楼层
    value = @"";
    if (self.housePtcl && self.housePtcl.build_floor_count)
    {
        value = self.housePtcl.build_floor_count;
        self.build_floor_count.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_total;
    //    //Float
    //    //总价(出售 万)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.sale_value_total)
        {
            value = [NSString stringWithFormat:@"%@万元",self.housePtcl.sale_value_total];
            self.sale_value_total.value =value;
        }
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * sale_value_single;
    //    //Float
    //    //单价(出售 元/平米)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.sale_value_single)
        {
            value = [NSString stringWithFormat:@"%@万元",self.housePtcl.sale_value_single];
             self.sale_value_single.value =value;
        }
    }
   
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * value_bottom;
    //    //Float
    //    //底价（出售 万）
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.value_bottom)
        {
            value = [NSString stringWithFormat:@"%@万元",self.housePtcl.value_bottom];
            self.value_bottom.value =value;
        }
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_total;
    //    //Float
    //    //总价(出租 元/月)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.lease_value_total)
        {
            value = [NSString stringWithFormat:@"%@万元",self.housePtcl.lease_value_total];
            self.lease_value_total.value =value;
        }
        
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RENumberItem * lease_value_single;
    //    //Float
    //    //单价(出租 元/月/平米)
    //todo 处理出租还是出售
    value = @"";
    if (self.housePtcl)
    {
        if (self.housePtcl.lease_value_single)
        {
            value = [NSString stringWithFormat:@"%@元",self.housePtcl.lease_value_single];
            self.lease_value_single.value =value;
        }
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
    //    //String
    //    //备注
    value = @"";
    if (self.housePtcl && self.housePtcl.client_remark)
    {
        value = self.housePtcl.client_remark;
        self.client_remark.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
    //    //String
    //    //房源描述
    value = @"";
    if (self.housePtcl && self.housePtcl.b_staff_describ)
    {
        value = self.housePtcl.b_staff_describ;
        self.b_staff_describ.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_staff_name;
    //    //String
    //    //经纪人姓名
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_staff_name)
    {
        value = self.housePtcl.owner_staff_name;
        self.owner_staff_name.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_staff_dept;
    //    //String
    //    //经纪人所属部门
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_staff_dept)
    {
        value = self.housePtcl.owner_staff_dept;
        self.owner_staff_dept.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_company_no;
    //    //String
    //    //经纪人所属公司编号
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_company_no)
    {
        value = self.housePtcl.owner_company_no;
        self.owner_company_no.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_compony_name;
    //    //String
    //    //经纪人所属公司名称
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_compony_name)
    {
        value = self.housePtcl.owner_compony_name;
        self.owner_compony_name.value =value;
    }
    
    
    //
    //    @property (strong, readwrite, nonatomic) RETextItem * owner_mobile;
    //    //String
    //    //经纪人电话
    value = @"";
    if (self.housePtcl && self.housePtcl.owner_mobile)
    {
        value = self.housePtcl.owner_mobile;
        self.owner_mobile.value =value;
    }
    
    
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
                self.client_source.value =value;
                break;
            }
        }
    }
    
    
    
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
                self.look_permit.value =value;
                break;
            }
        }
    }
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * sale_trade_state;
    //
    //
    // String
    // 状态（出售）
    value = @"";
    if (self.housePtcl && self.housePtcl.sale_trade_state)
    {
        value = self.housePtcl.sale_trade_state;
        self.sale_trade_state.value =value;
    }
    
    
    
    //@property (strong, readwrite, nonatomic) RERadioItem * lease_trade_state;
    //
    // String
    // 状态（出租）
    value = @"";
    if (self.housePtcl && self.housePtcl.lease_trade_state)
    {
        value = self.housePtcl.lease_trade_state;
        self.lease_trade_state.value =value;
    }
    
}

-(void)sumitBtnClicked:(id)sender
{
    if (self.housePtcl && self.houseSecretPtcl)
    {
        NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
        
        NSArray*arr = [self.infoSection items];
        
        for (RETableViewItem* item in arr)
        {
            NSString*name = [self nameOfInstance:item];
            if (name && [name hasPrefix:@"_"])
            {
                name = [name substringFromIndex:1];
                if ([name length] > 0)
                {
                    SEL sel =@selector(value);
                    if ([item respondsToSelector:sel])
                    {
                        NSString*vl = [item performSelector:sel];
                        NSString*tmp = [self convertToDicValueForItem:name FromValue:vl];
                        if ([tmp length] > 0)
                        {
                            vl = tmp;
                        }
                        [dic setValue:vl forKey:name];
                    }
                    
                }
            }
            
        }
        
        [dic setValue:self.houseDtl.house_trade_no forKey:@"house_trade_no"];
        SHOWHUD_WINDOW;
        [HouseDataPuller pushHouseEditedParticulars:dic Success:^(houseSecretParticulars *housePtl) {
            HIDEHUD_WINDOW;
            SEL sel = @selector(setNeedRefresh);
            if (self.delegate && [self.delegate respondsToSelector:sel])
            {
                [self.delegate performSelector:sel];
            }
            
            PRESENTALERTWITHHANDER(@"编辑成功",@"",@"OK",self,^(UIAlertAction *action)
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  );
            
            
        } failure:^(NSError *error) {
            HIDEHUD_WINDOW;
            NSString*errorStr = [NSString stringWithFormat:@"%@",error];
            PRESENTALERTWITHHANDER(@"编辑失败",errorStr,@"OK",self,^(UIAlertAction *action)
                                  {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }
                                  );
        }];
    }
}
-(void)prepareInfoSectionItems
{
//    [super prepareInfoSectionItems];
//    [self.infoSection removeItem:self.watchHouseImages];
//
//    [self.infoSection removeItem:self.buildings_name];
//    [self.infoSection removeItem:self.areaname];
//    [self.infoSection removeItem:self.urbanname];
//    [self.infoSection removeItem:self.buildings_address];
//    
//    [self.infoSection removeItem:self.tene_application];
//    [self.infoSection removeItem:self.house_model_type];
//    [self.infoSection removeItem:self.house_rank];
//    [self.infoSection removeItem:self.floor_height];
//    [self.infoSection removeItem:self.efficiency_rate];
//    [self.infoSection removeItem:self.house_depth];
//    [self.infoSection removeItem:self.build_floor_count];
//    [self.infoSection removeItem:self.floor_count];
//    [self.infoSection removeItem:self.house_and_build_floor];
//    
//    [self.infoSection removeItem:self.house_driect];
//    [self.infoSection removeItem:self.house_floor];
//
//    [self.infoSection removeItem:self.owner_staff_dept];
//    [self.infoSection removeItem:self.owner_staff_name];
//    [self.infoSection removeItem:self.owner_company_no];
//    [self.infoSection removeItem:self.owner_compony_name];
//    [self.infoSection removeItem:self.owner_mobile];
//    
//    [self.infoSection removeItem:self.lookSecretItem];
//    
//    
//    [self.infoSection removeItem:self.sale_value_single];
//    [self.infoSection removeItem:self.sale_value_total];
//    [self.infoSection removeItem:self.value_bottom];
//    [self.infoSection removeItem:self.lease_value_single];
//    [self.infoSection removeItem:self.lease_value_total];
//
//    
//    [self.infoSection removeItem:self.sale_trade_state];
//    [self.infoSection removeItem:self.lease_trade_state];
    
    
//    [self.infoSection removeAllItems];
//    
//
//    //
//    //    @property (strong, readwrite, nonatomic) RENumberItem * build_structure_area;
//    //    //float
//    //    //面积
//    [self.infoSection addItem:self.build_structure_area];
//    
//
//    //
//    //    @property (strong, readwrite, nonatomic) RETextItem * tene_type;
//    //    //Int
//    //    //物业类型
//    [self.infoSection addItem:self.tene_type];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RERadioItem * fitment_type;
//    //    //Int
//    //    //装修
//    [self.infoSection addItem:self.fitment_type];
//
//    //
//    //    @property (strong, readwrite, nonatomic) RETextItem * cons_elevator_brand;
//    //    //String
//    //    //电梯（如奥旳斯
//    [self.infoSection addItem:self.cons_elevator_brand];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RETextItem * facility_heating;
//    //    //String
//    //    //暖气
//    [self.infoSection addItem:self.facility_heating];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RETextItem * facility_gas;
//    //    //String
//    //    //燃气
//    [self.infoSection addItem:self.facility_gas];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) REDateTimeItem * build_year;
//    //    //Int
//    //    //建房年代
//    [self.infoSection addItem:self.build_year];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RENumberItem * build_property;
//    //    //Int
//    //    //产权年限
//    [self.infoSection addItem:self.build_property];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RERadioItem * use_situation;
//    //    //Int
//    //    //现状
//    [self.infoSection addItem:self.use_situation];
//    
//    
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RETextItem * client_remark;
//    //    //String
//    //    //备注
//    [self.infoSection addItem:self.client_remark];
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RETextItem * b_staff_describ;
//    //    //String
//    //    //房源描述
//    [self.infoSection addItem:self.b_staff_describ];
//    
//    
//    //
//    //    @property (strong, readwrite, nonatomic) RERadioItem * client_source;
//    //    //String
//    //    //信息来源
//    [self.infoSection addItem:self.client_source];
//    
//    
//    //@property (strong, readwrite, nonatomic) RERadioItem * look_permit;
//    //String
//    //看房:
//    //预约
//    //有钥匙
//    //借钥匙
//    //直接
//    [self.infoSection addItem:self.look_permit];
    
}

-(void)prepareSecretSectionItems
{
    [super prepareSecretSectionItems];
    [self.secretSection removeItem:self.look_permit];
    [self.secretSection removeItem:self.lookSecretItem];
    [self.secretSection addItem:self.client_name];
    [self.secretSection addItem:self.obj_mobile];
    
    [self.secretSection addItem:self.trade_type];
}



-(void)adjustByTradeType
{
    if ([self.trade_type.value length] > 0)
    {
        [self.secretSection removeItem:self.lease_trade_state];
        [self.secretSection removeItem:self.lease_value_total];
        [self.secretSection removeItem:self.lease_value_single];
        [self.secretSection removeItem:self.sale_trade_state];
        [self.secretSection removeItem:self.sale_value_total];
        [self.secretSection removeItem:self.sale_value_single];
        [self.secretSection removeItem:self.value_bottom];
        
        
        [self.secretSection addItem:self.sale_value_total];
        [self.secretSection addItem:self.sale_value_single];
        [self.secretSection addItem:self.value_bottom];
        [self.secretSection addItem:self.lease_value_total];
        [self.secretSection addItem:self.lease_value_single];
        
        
        if ([self.trade_type.value isEqualToString:@"出售"])
        {
            [self.secretSection removeItem:self.lease_trade_state];
            [self.secretSection removeItem:self.lease_value_total];
            [self.secretSection removeItem:self.lease_value_single];
        }
        else if ([self.trade_type.value isEqualToString:@"出租"])
        {
            [self.secretSection removeItem:self.sale_trade_state];
            [self.secretSection removeItem:self.sale_value_total];
            [self.secretSection removeItem:self.sale_value_single];
            [self.secretSection removeItem:self.value_bottom];
        }
        else if ([self.trade_type.value isEqualToString:@"租售"])
        {
            
        }
    }

    
    [self.tableView reloadData];
}

-(void)adjustExistingProps
{
    if (self.housePtcl)
    {
        NSInteger tradeType = [self.housePtcl.trade_type intValue];
        switch (tradeType)
        {
            case 1:
            case 2:
            case 3:
            {
                self.tene_application.value = self.housePtcl.tene_application;
                self.tene_application.enabled = NO;
                
                self.room_num.value = self.housePtcl.room_num;
                self.room_num.enabled = NO;
                
                self.hall_num.value = self.housePtcl.hall_num;
                self.hall_num.enabled = NO;
                
                self.kitchen_num.value = self.housePtcl.kitchen_num;
                self.kitchen_num.enabled = NO;
                
                self.toilet_num.value = self.housePtcl.toilet_num;
                self.toilet_num.enabled = NO;
                
                self.balcony_num.value = self.housePtcl.balcony_num;
                self.balcony_num.enabled = NO;
                
                self.house_driect.value = self.housePtcl.house_driect;
                self.house_driect.enabled = NO;
                
                self.house_depth.value = self.housePtcl.house_depth;
                self.house_depth.enabled = NO;
                
                self.floor_height.value = self.housePtcl.floor_height;
                self.floor_height.enabled = NO;
                
                self.floor_count.value = self.housePtcl.floor_count;
                self.floor_count.enabled = NO;
                
                self.efficiency_rate.value = self.housePtcl.efficiency_rate;
                self.efficiency_rate.enabled = NO;
                
                self.build_structure_area.value = self.housePtcl.build_structure_area;
                self.build_structure_area.enabled = NO;
                
                self.build_year.value = self.housePtcl.build_year;
                self.build_year.enabled = NO;
            }
                break;
            default:
                break;
        }
    }
}


-(void)getBuildingDetails
{
    SHOWHUD_WINDOW;
    
    [HouseDataPuller pullBuildingDetailsByBuildingNO:self.curBuildings.buildings_dict_no Success:^(buildingDetails *dtl,NSArray*arr)
     {
         [self.curBuilidngsOfCurBuildings removeAllObjects];
         if ([arr count] > 0)
         {
             [self.curBuilidngsOfCurBuildings addObjectsFromArray:arr];
             self.curBuildingsDetails = dtl;
         }
         else
         {
             PRESENTALERT(@"楼盘未录入栋座",@"请先联系主管添加栋座信息",@"OK",self);
         }
         HIDEHUD_WINDOW;
     }
                                            failure:^(NSError* error)
     {
         
         HIDEHUD_WINDOW;
     }];
}
-(void)createInfoSectionItems
{
    __typeof (&*self) __weak weakSelf = self;
    [super createInfoSectionItems];
    self.buildings_name = [[RERadioItem alloc] initWithTitle:@"楼盘名称:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        BuildingsSelectTableViewController*selCtrl = [BuildingsSelectTableViewController initWithDelegate:weakSelf AndCompleteHandler:^(buildings *bld) {
            if (bld)
            {
                //if (bld && self.curBuildings != bld)
                {
                    self.curBuildings = bld;
                    self.buildings_name.value = bld.buildings_name;
                    self.urbanname.value = bld.urbanname;
                    self.areaname.value = bld.areaname;
                    self.buildings_address.value = bld.Buildings_address;
                    [self.curBuilidngsOfCurBuildings removeAllObjects];
                    self.curBuildingsDetails = nil;
                    
                    self.buildname.enabled = YES;
                    
                    //self.house_tablet.enabled = YES;
                    
                    [self.tableView reloadData];
                    [self performSelectorOnMainThread:@selector(getBuildingDetails) withObject:nil waitUntilDone:NO];
                    
                }
                
                
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    
    
    
    self.buildname = [[RERadioItem alloc] initWithTitle:@"栋座:" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        HouseSelectBuildingTableViewController*selCtrl = [HouseSelectBuildingTableViewController initWithDelegate:weakSelf  BuildingsArr:self.curBuilidngsOfCurBuildings AndCompleteHandler:^(building *bld) {
            if (bld)
            {
                
                self.buildname.value = bld.build_full_name;
                self.build_floor_count.value = bld.floor_count;
                self.curBuilding = bld;
                self.house_serect_unit.enabled = YES;
                [self.tableView reloadData];
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    
    
    self.house_serect_unit = [[RERadioItem alloc] initWithTitle:@"单元:" value:@"" selectionHandler:^(RERadioItem *item)
    {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:[self.curBuilding getSerialArr] multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               
                                                               self.house_serect_unit.value = selectedItem.title;
                                                               self.house_tablet.enabled = YES;
                                                               self.judgementBtn.enabled = YES;
                                                               
                                                               
                                                               [self.tableView reloadData];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.teneApplicationAbout.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
}

-(void)prepareTeneApplicationSectionItemsStep1
{
    [self.teneApplicationAbout removeAllItems];
    __typeof (&*self) __weak weakSelf = self;

    
    NSInteger tradeType = [self.housePtcl.trade_type intValue];
    if (tradeType == 1 || tradeType == 2 || tradeType == 3)
    {
        
        
        
        self.tene_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:@"" selectionHandler:^(RERadioItem *item) {
        }];
        self.tene_application.enabled = NO;
        self.tene_application.value = self.housePtcl.tene_application;
        [self.teneApplicationAbout addItem:self.tene_application];
        [self prepareTeneApplicationSectionItemsStep2ByTenenType:self.housePtcl.tene_application];
        [self.tableView reloadData];
    }
    else
    {
        self.tene_application.enabled = YES;
        self.tene_application = [[RERadioItem alloc] initWithTitle:@"物业用途:" value:@"" selectionHandler:^(RERadioItem *item) {
            [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
            NSMutableArray *options = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < self.tene_application_dic_arr.count; i++)
            {
                DicItem *di = [self.tene_application_dic_arr objectAtIndex:i];
                [options addObject:di.dict_label];
            }
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                               {
                                                                   [weakSelf.navigationController popViewControllerAnimated:YES];

                                                                   [self prepareTeneApplicationSectionItemsStep2ByTenenType:selectedItem.title];
                                                                   
                                                                   //[item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                                               }];
            // Adjust styles
            optionsController.delegate = weakSelf;
            optionsController.style = self.teneApplicationAbout.style;
            if (weakSelf.tableView.backgroundView == nil)
            {
                optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                optionsController.tableView.backgroundView = nil;
            }
            // Push the options controller
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }];
        
        [self.teneApplicationAbout addItem:self.tene_application];
        [self.tableView reloadData];
    }
    
    
    
    
    
    
}

-(void)prepareTeneApplicationSectionItemsStep2ByTenenType:(NSString*)type
{
    [self.teneApplicationAbout removeItem:self.room_num];
    [self.teneApplicationAbout removeItem:self.hall_num];
    [self.teneApplicationAbout removeItem:self.kitchen_num];
    [self.teneApplicationAbout removeItem:self.toilet_num];
    [self.teneApplicationAbout removeItem:self.balcony_num];
    [self.teneApplicationAbout removeItem:self.house_driect];
    
    [self.teneApplicationAbout removeItem:self.efficiency_rate];
    [self.teneApplicationAbout removeItem:self.house_depth];
    [self.teneApplicationAbout removeItem:self.floor_height];
    [self.teneApplicationAbout removeItem:self.floor_count];
    [self.teneApplicationAbout removeItem:self.house_rank];
    
    [self.room_num setValue:@""];
    [self.hall_num setValue:@""];
    [self.kitchen_num setValue:@""];
    [self.toilet_num setValue:@""];
    [self.balcony_num setValue:@""];
    [self.house_driect setValue:@""];
    
    [self.efficiency_rate setValue:@""];
    [self.house_depth setValue:@""];
    [self.floor_height setValue:@""];
    [self.floor_count setValue:@""];
    [self.house_rank setValue:@""];
    
    
    self.floor_height.title = @"高度";
    if ([type  isEqualToString:@"商铺"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.house_driect];
        
    }
    else if([type  isEqualToString:@"商住"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else if([type  isEqualToString:@"厂房"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else if([type  isEqualToString:@"仓库"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else if([type  isEqualToString:@"地皮"])
    {
        self.house_rank.title = @"位置";
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.house_driect];

    }
    else if([type  isEqualToString:@"车位"])
    {
        self.house_rank.title = @"车位类型";
        [self.floor_height setTitle:@"宽度"];
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.house_depth];
        [self.teneApplicationAbout addItem:self.floor_height];
    }
    else if([type  isEqualToString:@"写字楼"])
    {
        self.house_rank.title = @"级别";
        
        [self.teneApplicationAbout addItem:self.house_rank];
        [self.teneApplicationAbout addItem:self.floor_height];
        [self.teneApplicationAbout addItem:self.floor_count];
        [self.teneApplicationAbout addItem:self.efficiency_rate];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    else
    {
        [self.teneApplicationAbout addItem:self.room_num];
        [self.teneApplicationAbout addItem:self.hall_num];
        [self.teneApplicationAbout addItem:self.kitchen_num];
        [self.teneApplicationAbout addItem:self.toilet_num];
        [self.teneApplicationAbout addItem:self.balcony_num];
        [self.teneApplicationAbout addItem:self.house_driect];
    }
    
    
    
    
    [self prepareInfoSectionItems];
    [self adjustExistingProps];
    [self prepareSecretSectionItems];
    
    
    [self.tableView reloadData];
}

-(void)prepareAddInfoSectionItems
{
    [self.addInfoSection removeAllItems];
    
    

    //楼盘
    [self.addInfoSection addItem:self.buildings_name];
    //区域
    self.urbanname.enabled = NO;
    [self.addInfoSection addItem:self.urbanname];
    //片区
    self.areaname.enabled = NO;
    [self.addInfoSection addItem:self.areaname];
    //地址
    self.buildings_address.enabled = NO;
    [self.addInfoSection addItem:self.buildings_address];
    //栋座
    self.buildname.enabled = NO;
    [self.addInfoSection addItem:self.buildname];
    //单元
    self.house_serect_unit.enabled = NO;
    [self.addInfoSection addItem:self.house_serect_unit];
    
    //门牌号
    self.house_tablet.enabled = NO;
    [self.addInfoSection addItem:self.house_tablet];
    
    //楼层
    self.house_floor.enabled = NO;
    [self.addInfoSection addItem:self.house_floor];
    
    //总楼层
    self.build_floor_count.enabled = NO;
    [self.addInfoSection addItem:self.build_floor_count];
    
    
    //@property(strong,nonatomic)RETableViewItem* judgementBtn;
    //判重按钮
    self.judgementBtn.enabled = NO;
    self.judgementBtn = [RETableViewItem itemWithTitle:@"判重" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                         {
                             [item deselectRowAnimated:YES];
                             
                             NSString*bldName = [self.buildname.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                             
                             NSString*unt = [self.house_serect_unit.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                             
                             NSString*tab = [self.house_tablet.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                             
                             if([bldName isEqualToString:@""] || [unt isEqualToString:@""] || [tab length] < 3 || self.curBuildings == nil || self.curBuilding ==nil)
                             {
                                 PRESENTALERT(@"请先填写完整房屋信息", nil, nil, self);
                             }
                             else
                             {
                                 
                                 NSString*tmpFloor =[self.house_tablet.value substringToIndex:2];
                                 NSInteger iFloor = [tmpFloor intValue];
                                 NSInteger iMaxFloor =[self.curBuilding.floor_count intValue];
                                 
                                 if (iFloor < 0 || iFloor > iMaxFloor)
                                 {
                                     PRESENTALERT(@"请填写正确的楼层", nil, nil, self);
                                 }
                                 else
                                 {
                                     tmpFloor = [NSString stringWithFormat:@"%ld",iFloor];
                                     self.house_floor.value = tmpFloor;
                                     [self judgeHouseByBuildings:self.curBuildings Building:self.curBuilding Unit:self.house_serect_unit.value Table:self.house_tablet.value];
                                 }
                                 
                             }
                             
                         }];
    self.judgementBtn.textAlignment = NSTextAlignmentCenter;
    //判重按钮
    [self.addInfoSection addItem:self.judgementBtn];
}

-(void)judgeHouseByBuildings:(buildings*)bldings Building:(building*)blding Unit:(NSString*)unit Table:(NSString*)table
{
    SHOWHUD_WINDOW;
    
    NSMutableDictionary*dic = [[NSMutableDictionary alloc] init];
    [dic setValue:blding.builds_dict_no forKey:@"builds_dict_no"];
    [dic setValue:unit forKey:@"house_unit"];
    [dic setValue:table forKey:@"house_tablet"];
    [dic setValue:[table substringToIndex:2] forKey:@"house_floor"];
    [HouseDataPuller pullIsHouseExisting:dic Success:^(HouseParticulars*hosuePtl)
     {
         self.housePtcl = hosuePtl;
         int tradeState = [hosuePtl.trade_type intValue];
         switch (tradeState)
         {
             case 0:
             {
                 PRESENTALERT(@"该房源尚未添加", @"可以添加房源,并添加:出售,出租,租售三种交易信息", nil, self);
             }
                 break;
             case 1:
             {
                 PRESENTALERT(@"该房源已添加", @"可以添加:出售,出租,租售三种交易信息", nil, self);
             }
                 break;
             case 2:
             {
                 PRESENTALERT(@"该房源存在出售交易信息", @"只能添加:出租交易信息", nil, self);
             }
                 break;
             case 3:
             {
                 PRESENTALERT(@"该房源存在出租交易信息", @"只能添加:出售交易信息", nil, self);
             }
                 break;
             case 4:
             {
                 PRESENTALERT(@"该房源存在租售交易信息", @"不能再添加交易信息", nil, self);
             }
                 break;
             default:
                 break;
         }
         
         [self prepareTeneApplicationSectionItemsStep1];
         HIDEHUD_WINDOW;
     }
                                             failure:^(NSError* error)
     {
         
         HIDEHUD_WINDOW;
     }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
