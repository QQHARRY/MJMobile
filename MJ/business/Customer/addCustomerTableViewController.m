//
//  addCustomerTableViewController.m
//  MJ
//
//  Created by harry on 15/1/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "addCustomerTableViewController.h"

@interface addCustomerTableViewController ()

@end

@implementation addCustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSections];
    [self createItems];
}

-(void)initSections
{
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    CGFloat sectH = 44;
    self.customerBaseInfoSection = [RETableViewSection sectionWithHeaderTitle:@"基本信息"];
    self.customerBaseInfoSection.headerHeight = sectH;
    
    self.customerRequireSection = [RETableViewSection sectionWithHeaderTitle:@"需求信息"];
    self.customerRequireSection.headerHeight = sectH;
    
    self.tradeTypeSection = [RETableViewSection sectionWithHeaderTitle:@"交易信息"];
    self.tradeTypeSection.headerHeight =sectH;
    
    self.remarkSection = [RETableViewSection sectionWithHeaderTitle:@"其他信息"];
    self.remarkSection.headerHeight = sectH;
    
    self.staffSection = [RETableViewSection sectionWithHeaderTitle:@""];
    self.staffSection.headerHeight = 1;
    
    [self.manager addSection:self.customerBaseInfoSection];
    [self.manager addSection:self.customerRequireSection];
    [self.manager addSection:self.tradeTypeSection];
    [self.manager addSection:self.remarkSection];
    [self.manager addSection:self.staffSection];
}


-(void)createItems
{
    [self createBaseInfoSection];
    [self createRequireItems];
    [self createTradeTypeItems];
    [self createOtherItems];
}


-(void)createBaseInfoSection
{
//    @property(nonatomic,strong) RERadioItem *requirement_status;//客源状态
    self.requirement_status = [[RERadioItem alloc] initWithTitle:@"客源状态" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerBaseInfoSection addItem:self.requirement_status];
    
//    @property(nonatomic,strong) RETextItem *client_name;//客户姓名
    self.client_name = [[RETextItem alloc] initWithTitle:@"客户姓名" value:@""];
    [self.customerBaseInfoSection addItem:self.client_name];
    
//    @property(nonatomic,strong) RERadioItem *client_gender;//客户性别
    self.client_gender = [[RERadioItem alloc] initWithTitle:@"性别" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerBaseInfoSection addItem:self.client_gender];
    
//    @property(nonatomic,strong) RERadioItem *client_level;//客户等级
    self.client_level = [[RERadioItem alloc] initWithTitle:@"客户等级" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerBaseInfoSection addItem:self.client_level];
    
    
//    @property(nonatomic,strong) RERadioItem *client_background;//客户类别
    self.client_background = [[RERadioItem alloc] initWithTitle:@"客户类别" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerBaseInfoSection addItem:self.client_background];
    
    
//    @property(nonatomic,strong) RETextItem *mobilePhone;//手机
    self.mobilePhone = [[RETextItem alloc] initWithTitle:@"手机" value:@""];
    [self.customerBaseInfoSection addItem:self.mobilePhone];
    
//    @property(nonatomic,strong) RETextItem *fixPhone;//固话
    self.fixPhone = [[RETextItem alloc] initWithTitle:@"固话" value:@""];
    [self.customerBaseInfoSection addItem:self.fixPhone];
    
    
    
//    @property(nonatomic,strong) RETextItem *idCardNO;//身份证
    self.idCardNO = [[RETextItem alloc] initWithTitle:@"身份证号" value:@""];
    [self.customerBaseInfoSection addItem:self.idCardNO];
    
    
//    @property(nonatomic,strong) RETextItem *homeAddress;//家庭地址
    self.homeAddress = [[RETextItem alloc] initWithTitle:@"家庭地址" value:@""];
    [self.customerBaseInfoSection addItem:self.homeAddress];

}

-(void)createRequireItems
{
    //    @property(nonatomic,strong) RERadioItem *requirement_house_urban;//所属城区编号
    self.requirement_house_urban = [[RERadioItem alloc] initWithTitle:@"需求城区" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_house_urban];
    
    //    @property(nonatomic,strong) RERadioItem *requirement_house_area;//所属片区编号
    self.requirement_house_area = [[RERadioItem alloc] initWithTitle:@"需求片区" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_house_area];
    
    
    //    @property(nonatomic,strong) RERadioItem *buildings_name;//楼盘编号
    self.buildings_name = [[RERadioItem alloc] initWithTitle:@"楼盘编号" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.buildings_name];
    
    
    //    @property(nonatomic,strong) RERadioItem *requirement_tene_application;//物业用途
    self.requirement_tene_application = [[RERadioItem alloc] initWithTitle:@"物业用途" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_tene_application];
    
    //    @property(nonatomic,strong) RERadioItem *requirement_tene_type;//物业类型
    self.requirement_tene_type = [[RERadioItem alloc] initWithTitle:@"物业类型" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_tene_type];
    
    
    //    @property(nonatomic,strong) RERadioItem *requirement_fitment_type;//装修类型
    self.requirement_fitment_type = [[RERadioItem alloc] initWithTitle:@"装修类型" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_fitment_type];
    
    
    //    @property(nonatomic,strong) RERadioItem *requirement_house_driect;//朝向
    self.requirement_house_driect = [[RERadioItem alloc] initWithTitle:@"朝向" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_house_driect];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_floor_from;//Int最低楼层要求
    self.requirement_floor_from = [[RENumberItem alloc] initWithTitle:@"最低楼层要求" value:@""];
    [self.customerRequireSection addItem:self.requirement_floor_from];
    
    
    //    @property(nonatomic,strong) RENumberItem *requirement_floor_to;//Int最高楼层要求
    self.requirement_floor_to = [[RENumberItem alloc] initWithTitle:@"最高楼层要求" value:@""];
    [self.customerRequireSection addItem:self.requirement_floor_to];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_room_from;//Int最少卧室数量 要求
    self.requirement_room_from = [[RENumberItem alloc] initWithTitle:@"最少卧室数量" value:@""];
    [self.customerRequireSection addItem:self.requirement_room_from];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_room_to;//Int最大卧室数量 要求
    self.requirement_room_to = [[RENumberItem alloc] initWithTitle:@"最大卧室数量" value:@""];
    [self.customerRequireSection addItem:self.requirement_room_to];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_hall_from;//Int最少厅数量要 求
    self.requirement_hall_from = [[RENumberItem alloc] initWithTitle:@"最少厅数量" value:@""];
    [self.customerRequireSection addItem:self.requirement_hall_from];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_hall_to;//Int最大厅数量要 求
    self.requirement_hall_to = [[RENumberItem alloc] initWithTitle:@"最大厅数量" value:@""];
    [self.customerRequireSection addItem:self.requirement_hall_to];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_area_from;//最小面积要求
    self.requirement_area_from = [[RENumberItem alloc] initWithTitle:@"最小面积要求" value:@""];
    [self.customerRequireSection addItem:self.requirement_area_from];
    
    //    @property(nonatomic,strong) RENumberItem *requirement_area_to;//String最大面积要求
    self.requirement_area_to = [[RENumberItem alloc] initWithTitle:@"最大面积要求" value:@""];
    [self.customerRequireSection addItem:self.requirement_area_to];
    
    //    @property(nonatomic,strong) RERadioItem *requirement_client_source;//String客户来源
    self.requirement_client_source = [[RERadioItem alloc] initWithTitle:@"客户来源" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.customerRequireSection addItem:self.requirement_client_source];
    
}

-(void)createTradeTypeItems
{
    //    @property(nonatomic,strong) RENumberItem *requirement_sale_price_from;//String//￼最低求购价格
    self.requirement_sale_price_from = [[RENumberItem alloc] initWithTitle:@"最低求购价格" value:@""];
    
    
    //    @property(nonatomic,strong) RENumberItem *requirement_sale_price_to;//最高求购价格
    self.requirement_sale_price_to = [[RENumberItem alloc] initWithTitle:@"最高求购价格" value:@""];
    
    
    //    @property(nonatomic,strong) RERadioItem *sale_price_unit;//求购价格单位
    self.sale_price_unit = [[RERadioItem alloc] initWithTitle:@"求购价格单位" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    
    
    //    @property(nonatomic,strong) RENumberItem *requirement_lease_price_from;//最低求租价格
    self.requirement_lease_price_from = [[RENumberItem alloc] initWithTitle:@"最低求租价格" value:@""];
    
    
    //    @property(nonatomic,strong) RENumberItem *requirement_lease_price_to;//最高求租价格
    self.requirement_lease_price_to = [[RENumberItem alloc] initWithTitle:@"最高求租价格" value:@""];
    
    
    //    @property(nonatomic,strong) RERadioItem *lease_price_unit;//求租价格单位
    self.lease_price_unit = [[RERadioItem alloc] initWithTitle:@"求租价格单位" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    
    //    @property(nonatomic,strong) RERadioItem *business_requirement_type;//求租或求购
    self.business_requirement_type = [[RERadioItem alloc] initWithTitle:@"租购" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.tradeTypeSection addItem:self.business_requirement_type];
}

-(void)createOtherItems
{
    //    @property(nonatomic,strong) RETextItem *requirement_memo;//备注
    self.requirement_memo = [[RETextItem alloc] initWithTitle:@"备注" value:@""];
    [self.remarkSection addItem:self.requirement_memo];
    
    
    
    //    @property(nonatomic,strong) RERadioItem *name_full;//置业顾问名字
    self.name_full = [[RERadioItem alloc] initWithTitle:@"置业顾问" value:@"" selectionHandler:^(RERadioItem *item) {
        
    }];
    [self.staffSection addItem:self.name_full];
}

-(void)adjustItems
{
    
}

@end
