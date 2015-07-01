//
//  CustomerParticularTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "CustomerParticularTableViewController.h"
#import "UtilFun.h"
#import "FollowTableViewController.h"
#import "AppointTableViewController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "CustomerDataPuller.h"
#import "HouseDataPuller.h"
#import "editCustomerTableViewController.h"

@interface CustomerParticularTableViewController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *customerSection;
@property (strong, readwrite, nonatomic) RETextItem *customerIdItem;
@property (strong, readwrite, nonatomic) RETextItem *customerNameItem;
@property (strong, readwrite, nonatomic) RETextItem *customerLevelItem;
@property (strong, readwrite, nonatomic) RETextItem *customerStatusItem;
@property (strong, readwrite, nonatomic) RETextItem *customerGenderItem;
@property (strong, readwrite, nonatomic) RETextItem *customerBackgroundItem;
@property (strong, readwrite, nonatomic) RETextItem *urbanItem;
@property (strong, readwrite, nonatomic) RETextItem *areaItem;
@property (strong, readwrite, nonatomic) RETextItem *buildingsItem;
@property (strong, readwrite, nonatomic) RETextItem *requireTypeItem;
@property (strong, readwrite, nonatomic) RETextItem *requireFloorItem;
@property (strong, readwrite, nonatomic) RETextItem *requireRoomItem;
@property (strong, readwrite, nonatomic) RETextItem *requireHallItem;
@property (strong, readwrite, nonatomic) RETextItem *requireAreaItem;
@property (strong, readwrite, nonatomic) RETextItem *sourceItem;
@property (strong, readwrite, nonatomic) RETextItem *buyPriceItem;
@property (strong, readwrite, nonatomic) RETextItem *rentPriceItem;
@property (strong, readwrite, nonatomic) RETextItem *teneAppItem;
@property (strong, readwrite, nonatomic) RETextItem *teneTypeItem;
@property (strong, readwrite, nonatomic) RETextItem *fitmentItem;
@property (strong, readwrite, nonatomic) RETextItem *direntItem;
@property (strong, readwrite, nonatomic) RETextItem *salesItem;
@property (strong, readwrite, nonatomic) RETextItem *salesCompItem;
@property (strong, readwrite, nonatomic) RETextItem *salesDeptItem;
@property (strong, readwrite, nonatomic) RELongTextItem *memoItem;

@property (strong, readwrite, nonatomic) RETableViewSection *secretSection;
@property (strong, readwrite, nonatomic) RETableViewItem *secretActionItem;
@property (strong, readwrite, nonatomic) RETableViewItem *unsecretItem;
@property (strong, readwrite, nonatomic) RETextItem *sMobileItem;
@property (strong, readwrite, nonatomic) RETextItem *sTelItem;
@property (strong, readwrite, nonatomic) RETextItem *sIdItem;
@property (strong, readwrite, nonatomic) RETextItem *sAddressItem;

@property (strong, readwrite, nonatomic) RETableViewSection *actionSection;
@property (strong, readwrite, nonatomic) RETableViewItem *followActionItem;
@property (strong, readwrite, nonatomic) RETableViewItem *appointActionItem;

@property (nonatomic, strong) NSArray *customerLevelDicList;
@property (nonatomic, strong) NSArray *customerStatusDicList;
@property (nonatomic, strong) NSArray *sourceDicList;
@property (nonatomic, strong) NSArray *teneAppDicList;
@property (nonatomic, strong) NSArray *teneTypeDicList;
@property (nonatomic, strong) NSArray *fitmentDicList;
@property (nonatomic, strong) NSArray *direntDicList;
@property (nonatomic, strong) NSArray *genderDicList;
@property (nonatomic, strong) NSArray *backgroundDicList;
@property (nonatomic, strong) NSArray *areaDictList;

@property (strong, nonatomic) CustomerSecret *secret;


@property (assign,nonatomic)BOOL wantEditSerect;

@end

@implementation CustomerParticularTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // title
    self.title = @"客源详情";
    
    // get dict
    self.customerLevelDicList = [dictionaryManager getItemArrByType:DIC_CLIENT_LEVEL];
    self.customerStatusDicList = [dictionaryManager getItemArrByType:DIC_REQUIREMENT_STATE];
    self.genderDicList = [dictionaryManager getItemArrByType:DIC_SEX_TYPE];
    self.backgroundDicList = [dictionaryManager getItemArrByType:DIC_CLIENT_BG];
    self.sourceDicList = [dictionaryManager getItemArrByType:DIC_CLIENT_SOURCE_TYPE];
    self.teneAppDicList = [dictionaryManager getItemArrByType:DIC_TENE_APPLICATION];
    self.teneTypeDicList = [dictionaryManager getItemArrByType:DIC_TENE_TYPE];
    self.fitmentDicList = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.direntDicList = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
    self.areaDictList = [NSArray array];
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.customerSection = [RETableViewSection sectionWithHeaderTitle:@"基本信息"];
    [self.manager addSection:self.customerSection];
    self.secretSection = [RETableViewSection sectionWithHeaderTitle:@"保密信息"];
    [self.manager addSection:self.secretSection];
    self.actionSection = [RETableViewSection sectionWithHeaderTitle:@"相关操作"];
    [self.manager addSection:self.actionSection];
    
    self.wantEditSerect = NO;

    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData
{
    SHOWHUD_WINDOW;
    [CustomerDataPuller pullCustomerParticulars:self.detail Success:^(CustomerParticulars *particulars)
    {
        HIDEHUD_WINDOW;
        self.particulars = particulars;
        SHOWHUD_WINDOW;
        [HouseDataPuller pullAreaListDataSuccess:^(NSArray *areaList)
         {
             HIDEHUD_WINDOW;
             self.areaDictList = areaList;
             [self reloadUI];
         }
                                         failure:^(NSError *error)
         {
             HIDEHUD_WINDOW;
             PRESENTALERT(@"获取失败", @"可能是网络问题，请稍候再试", @"O K", nil,self);
         }];
    }
                                        failure:^(NSError *error)
    {
        HIDEHUD_WINDOW;
        PRESENTALERT(@"获取失败", @"可能是网络问题，请稍候再试", @"O K", nil,self);
    }];
}

-(void)reloadUI
{
    __typeof (&*self) __weak weakSelf = self;

    [self.customerSection removeAllItems];
    self.customerIdItem = [RETextItem itemWithTitle:@"客户编号:" value:self.particulars.client_base_no placeholder:@""];
    self.customerIdItem.enabled = false;
    [self.customerSection addItem:self.customerIdItem];
    self.customerNameItem = [RETextItem itemWithTitle:@"客户姓名:" value:self.particulars.client_name placeholder:@""];
    self.customerNameItem.enabled = false;
    [self.customerSection addItem:self.customerNameItem];
    {
        NSString *l = @"";
        for (DicItem *di in self.customerLevelDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.client_level])
            {
                l = di.dict_label;
                break;
            }
        }
        self.customerLevelItem = [RETextItem itemWithTitle:@"客户等级:" value:l placeholder:@""];
        self.customerLevelItem.enabled = false;
        [self.customerSection addItem:self.customerLevelItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.customerStatusDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.requirement_status])
            {
                l = di.dict_label;
                break;
            }
        }
        self.customerStatusItem = [RETextItem itemWithTitle:@"客源状态:" value:l placeholder:@""];
        self.customerStatusItem.enabled = false;
        [self.customerSection addItem:self.customerStatusItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.genderDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.client_gender])
            {
                l = di.dict_label;
                break;
            }
        }
        self.customerGenderItem = [RETextItem itemWithTitle:@"客户性别:" value:l placeholder:@""];
        self.customerGenderItem.enabled = false;
        [self.customerSection addItem:self.customerGenderItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.backgroundDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.client_background])
            {
                l = di.dict_label;
                break;
            }
        }
        self.customerBackgroundItem = [RETextItem itemWithTitle:@"客户类别:" value:l placeholder:@""];
        self.customerBackgroundItem.enabled = false;
        [self.customerSection addItem:self.customerBackgroundItem];
    }
    {
        NSString *l = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            NSString *hno = [areaDict objectForKey:@"no"];
            if ([hno isEqualToString:self.particulars.requirement_house_urban])
            {
                l = [[areaDict objectForKey:@"dict"] objectForKey:@"area_name"];
                break;
            }
        }
        self.urbanItem = [RETextItem itemWithTitle:@"所属城区:" value:l placeholder:@""];
        self.urbanItem.enabled = false;
        [self.customerSection addItem:self.urbanItem];
    }
    {
        NSString *l = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            NSArray *sectionList = [areaDict objectForKey:@"sections"];
            BOOL bFind = false;
            for (NSDictionary *sectionDict in sectionList)
            {
                if ([[sectionDict objectForKey:@"area_cno"] isEqualToString:self.particulars.requirement_house_area])
                {
                    l = [sectionDict objectForKey:@"area_name"];
                    bFind = true;
                    break;
                }
            }
            if (bFind)
            {
                break;
            }
        }
        self.areaItem = [RETextItem itemWithTitle:@"所属片区:" value:l placeholder:@""];
        self.areaItem.enabled = false;
        [self.customerSection addItem:self.areaItem];
    }
    self.buildingsItem = [RETextItem itemWithTitle:@"需求楼盘:" value:self.particulars.buildings_name placeholder:@""];
    self.buildingsItem.enabled = false;
    [self.customerSection addItem:self.buildingsItem];
    {
        NSString *l = @"";
        if ([self.particulars.business_requirement_type isEqualToString:@"200"])
        {
            l = @"求购";
        }
        else if ([self.particulars.business_requirement_type isEqualToString:@"201"])
        {
            l = @"求租";
        }
        else if ([self.particulars.business_requirement_type isEqualToString:@"202"])
        {
            l = @"租购";
        }
        self.requireTypeItem = [RETextItem itemWithTitle:@"需求类型:" value:l placeholder:@""];
        self.requireTypeItem.enabled = false;
        [self.customerSection addItem:self.requireTypeItem];
    }
    self.requireFloorItem = [RETextItem itemWithTitle:@"楼层要求:" value:[NSString stringWithFormat:@"%@-%@层", self.particulars.requirement_floor_from,  self.particulars.requirement_floor_to] placeholder:@""];
    self.requireFloorItem.enabled = false;
    [self.customerSection addItem:self.requireFloorItem];
    self.requireRoomItem = [RETextItem itemWithTitle:@"卧室要求:" value:[NSString stringWithFormat:@"%@-%@室", self.particulars.requirement_room_from,  self.particulars.requirement_room_to] placeholder:@""];
    self.requireRoomItem.enabled = false;
    [self.customerSection addItem:self.requireRoomItem];
    self.requireHallItem = [RETextItem itemWithTitle:@"客厅要求:" value:[NSString stringWithFormat:@"%@-%@厅", self.particulars.requirement_hall_from,  self.particulars.requirement_hall_to] placeholder:@""];
    self.requireHallItem.enabled = false;
    [self.customerSection addItem:self.requireHallItem];
    self.requireAreaItem = [RETextItem itemWithTitle:@"面积要求:" value:[NSString stringWithFormat:@"%@-%@m²", self.particulars.requirement_area_from,  self.particulars.requirement_area_to] placeholder:@""];
    self.requireAreaItem.enabled = false;
    [self.customerSection addItem:self.requireAreaItem];
    if ([self.particulars.business_requirement_type isEqualToString:@"200"] || [self.particulars.business_requirement_type isEqualToString:@"202"])
    {
        self.buyPriceItem = [RETextItem itemWithTitle:@"求购价格:" value:[NSString stringWithFormat:@"%@-%@%@", self.particulars.requirement_sale_price_from,  self.particulars.requirement_sale_price_to, self.particulars.sale_price_unit] placeholder:@""];
        self.buyPriceItem.enabled = false;
        [self.customerSection addItem:self.buyPriceItem];
    }
    if ([self.particulars.business_requirement_type isEqualToString:@"201"] || [self.particulars.business_requirement_type isEqualToString:@"202"])
    {
        self.rentPriceItem = [RETextItem itemWithTitle:@"求租价格:" value:[NSString stringWithFormat:@"%@-%@%@", self.particulars.requirement_lease_price_from,  self.particulars.requirement_lease_price_to, self.particulars.lease_price_unit] placeholder:@""];
        self.rentPriceItem.enabled = false;
        [self.customerSection addItem:self.rentPriceItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.teneAppDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.requirement_tene_application])
            {
                l = di.dict_label;
                break;
            }
        }
        self.teneAppItem = [RETextItem itemWithTitle:@"物业用途:" value:l placeholder:@""];
        self.teneAppItem.enabled = false;
        [self.customerSection addItem:self.teneAppItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.teneTypeDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.requirement_tene_type])
            {
                l = di.dict_label;
                break;
            }
        }
        self.teneTypeItem = [RETextItem itemWithTitle:@"物业类型:" value:l placeholder:@""];
        self.teneTypeItem.enabled = false;
        [self.customerSection addItem:self.teneTypeItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.fitmentDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.requirement_fitment_type])
            {
                l = di.dict_label;
                break;
            }
        }
        self.fitmentItem = [RETextItem itemWithTitle:@"装修要求:" value:l placeholder:@""];
        self.fitmentItem.enabled = false;
        [self.customerSection addItem:self.fitmentItem];
    }

    {
        NSString *l = @"";
        for (DicItem *di in self.direntDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.requirement_house_driect])
            {
                l = di.dict_label;
                break;
            }
        }
        self.direntItem = [RETextItem itemWithTitle:@"朝向要求:" value:l placeholder:@""];
        self.direntItem.enabled = false;
        [self.customerSection addItem:self.direntItem];
    }
    {
        NSString *l = @"";
        for (DicItem *di in self.sourceDicList)
        {
            if ([di.dict_value isEqualToString:self.particulars.requirement_client_source])
            {
                l = di.dict_label;
                break;
            }
        }
        self.sourceItem = [RETextItem itemWithTitle:@"客户来源:" value:l placeholder:@""];
        self.sourceItem.enabled = false;
        [self.customerSection addItem:self.sourceItem];
    }
    self.salesItem = [RETextItem itemWithTitle:@"置业顾问:" value:self.particulars.name_full placeholder:@""];
    self.salesItem.enabled = false;
    [self.customerSection addItem:self.salesItem];
    self.salesCompItem = [RETextItem itemWithTitle:@"顾问公司:" value:self.particulars.comp_no placeholder:@""];
    self.salesCompItem.enabled = false;
    //[self.customerSection addItem:self.salesCompItem];
    self.salesDeptItem = [RETextItem itemWithTitle:@"顾问部门:" value:self.particulars.dept_name/*b_dept_no*/ placeholder:@""];
    self.salesDeptItem.enabled = false;
    [self.customerSection addItem:self.salesDeptItem];
    [self.customerSection addItem:@"备注:"];
    self.memoItem = [RELongTextItem itemWithValue:self.particulars.requirement_memo placeholder:@""];
    self.memoItem.cellHeight = 100;
    self.memoItem.enabled = false;
    [self.customerSection addItem:self.memoItem];

    [self.secretSection removeAllItems];
    if (self.secret)
    {
        self.sMobileItem = [RETextItem itemWithTitle:@"手机号码:" value:self.secret.obj_mobile placeholder:@""];
        self.sMobileItem.enabled = false;
        [self.secretSection addItem:self.sMobileItem];
        self.sTelItem = [RETextItem itemWithTitle:@"固定电话:" value:self.secret.obj_fixtel placeholder:@""];
        self.sTelItem.enabled = false;
        [self.secretSection addItem:self.sTelItem];
        self.sIdItem = [RETextItem itemWithTitle:@"身份证号:" value:self.secret.client_identity placeholder:@""];
        self.sIdItem.enabled = false;
        [self.secretSection addItem:self.sIdItem];
        self.sAddressItem = [RETextItem itemWithTitle:@"家庭住址:" value:self.secret.obj_address placeholder:@""];
        self.sAddressItem.enabled = false;
        [self.secretSection addItem:self.sAddressItem];
    }
    else
    {
        // add title button
        if ([self.particulars.edit_permit isEqualToString:@"1"])
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onEditAction:)];
        }
        if ([self.particulars.edit_permit isEqualToString:@"1"] || [self.particulars.secret_permit isEqualToString:@"1"])
        {
            self.secretActionItem = [RETableViewItem itemWithTitle:@"查看保密信息" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                     {
                                         [self pullSecret];
                                     }];
            self.secretActionItem.textAlignment = NSTextAlignmentCenter;
            [self.secretSection addItem:self.secretActionItem];
        }
        else
        {
            self.unsecretItem = [RETableViewItem itemWithTitle:@"您无权查看保密信息" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                                     {
                                     }];
            self.unsecretItem.textAlignment = NSTextAlignmentCenter;
            [self.secretSection addItem:self.unsecretItem];
        }
    }

    [self.actionSection removeAllItems];
    self.followActionItem = [RETableViewItem itemWithTitle:@"跟进" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                             {
                                 [item deselectRowAnimated:YES];
                                 
                                 
                                 FollowTableViewController *vc = [[FollowTableViewController alloc] initWithNibName:@"FollowTableViewController" bundle:[NSBundle mainBundle]];
                                 vc.sid = self.detail.business_requirement_no;
                                 
                                 if ([self.particulars.edit_permit isEqualToString:@"1"] || [self.particulars.secret_permit isEqualToString:@"1"])
                                 {
                                     vc.hasAddPermit = YES;
                                 }
                                 else
                                 {
                                     vc.hasAddPermit = NO;
                                 }
                                 
                                 
                                 if ([self.particulars.business_requirement_type isEqualToString:@"200"])
                                 {
                                     vc.type = @"求购";
                                 }
                                 else if ([self.particulars.business_requirement_type isEqualToString:@"201"])
                                 {
                                     vc.type = @"求租";
                                 }
                                 else if ([self.particulars.business_requirement_type isEqualToString:@"202"])
                                 {
                                     vc.type = @"租购";
                                 }
                                 else
                                 {
                                     assert(false);
                                 }
                                 [weakSelf.navigationController pushViewController:vc animated:YES];
                             }];
    self.followActionItem.textAlignment = NSTextAlignmentCenter;
    [self.actionSection addItem:self.followActionItem];
    self.appointActionItem = [RETableViewItem itemWithTitle:@"带看" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                              {
                                  AppointTableViewController *vc = [[AppointTableViewController alloc] initWithNibName:@"AppointTableViewController" bundle:[NSBundle mainBundle]];
                                  vc.sid = self.detail.business_requirement_no;
                                  [weakSelf.navigationController pushViewController:vc animated:YES];
                              }];
    self.appointActionItem.textAlignment = NSTextAlignmentCenter;
    [self.actionSection addItem:self.appointActionItem];

    [self.tableView reloadData];
}

-(void)pullSecret
{
    SHOWHUD_WINDOW;
    [CustomerDataPuller pullCustomerSecret:self.detail Success:^(CustomerSecret *secret)
     {
         HIDEHUD_WINDOW;
         self.secret = secret;
         if (self.wantEditSerect)
         {
             self.wantEditSerect = NO;
             [self onEditAction:nil];
         }
         else
         {
             
             [self reloadUI];
         }
         
     }
                                        failure:^(NSError *error)
     {
         HIDEHUD_WINDOW;
         PRESENTALERT(@"获取失败", @"可能是网络问题，请稍候再试", @"OK", nil,self);
     }];
}

-(void)onEditAction:(id)sender
{
    __typeof (&*self) __weak weakSelf = self;

    if (self.particulars && self.secret)
    {
        editCustomerTableViewController*editCtrl = [editCustomerTableViewController editCtrlWithCusParticulars:self.particulars AndSecrect:self.secret AreaDic:self.areaDictList Hander:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            PRESENTALERT(@"编辑成功", nil, nil, nil,nil);
            [self reloadData];
        }];
        
        editCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editCtrl animated:YES];
        
        
        
    }
    else if(self.particulars)
    {
        self.wantEditSerect = YES;
        [self pullSecret];
    }
    
    
    
}

@end
