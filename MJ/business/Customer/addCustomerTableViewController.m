//
//  addCustomerTableViewController.m
//  MJ
//
//  Created by harry on 15/1/25.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "addCustomerTableViewController.h"
#import "Macro.h"
#import "dictionaryManager.h"
#import "RETableViewOptionsController.h"
#import "HouseDataPuller.h"
#import "UtilFun.h"
#import "BuildingsSelectTableViewController.h"
#import "AppDelegate.h"
#import "CustomerDataPuller.h"


@interface addCustomerTableViewController ()

@end

@implementation addCustomerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];
    [self initDic];
    [self initSections];
    [self createItems];
}

-(BOOL)checkField:(NSArray*)fields
{
    BOOL allOK = YES;
    int count = 0;
    NSString* all = @"";
    
    NSArray* clsArr = @[[RETextItem class],
                        [RERadioItem class],
                        [RENumberItem class],
                        [RELongTextItem class]];
    
    if (fields)
    {
        for (RETableViewItem*item in fields)
        {
            for (Class cls in clsArr)
            {
                if ([item isKindOfClass:cls])
                {
                    SEL sel =@selector(value);
                    if ([item respondsToSelector:sel])
                    {
                        NSString*vl = [item performSelector:sel];
                        vl = [vl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if ([vl isEqualToString:@""])
                        {
                            all = [all stringByAppendingString:item.title];
                            all = [all stringByAppendingString:@"\r\n"];
                            allOK = NO;
                            count++;
                        }
                    }
                    break;
                }
            }
        }
    }
    
    if (!allOK)
    {
        NSString* promptTitle = [NSString stringWithFormat:@"有%d个必填信息未填!",count];
        
        
        all = [all stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        PRESENTALERT(promptTitle, all, nil, nil);
    }
    
    return allOK;
}

-(NSString*)DicValueFromValue:(NSString*)value AndDic:(NSArray*)dicArr
{
    if ([value isEqualToString:@""] || dicArr == nil || [dicArr count] == 0)
    {
        return value;
    }
    
    
    for (DicItem*item in dicArr)
    {
        if ([item.dict_label isEqualToString:value])
        {
            return item.dict_value;
        }
        
    }
    
    return value;
}


-(void)sumitBtnClicked:(id)sender
{
    
    NSArray*requiredFields =@[self.client_name,
                              self.mobilePhone,
                              self.requirement_house_urban,
                              self.requirement_house_area,
                              self.requirement_floor_from,
                              self.requirement_floor_to,
                              self.requirement_room_from,
                              self.requirement_room_to,
                              self.requirement_hall_from,
                              self.requirement_hall_to,
                              self.requirement_area_from,
                              self.requirement_area_to,
                              self.requirement_client_source
                              ];
    if (![self checkField:requiredFields])
    {
        return;
    }
    
    if ([self.requirement_floor_to.value intValue] == 0 ||
        [self.requirement_floor_from.value intValue] == 0)
    {
        PRESENTALERT(@"需求楼层不能为0", nil, nil, nil);
        return;
    }
    
    if ([self.requirement_room_to.value intValue] == 0 ||
        [self.requirement_room_from.value intValue] == 0)
    {
        PRESENTALERT(@"需求户型不能填0室", nil, nil, nil);
        return;
    }
    
    if ([self.requirement_area_to.value floatValue] < 3 ||
        [self.requirement_area_from.value floatValue] < 3)
    {
        PRESENTALERT(@"需求面积不能小于3", nil, nil, nil);
        return;
    }
    
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    NSString*value = @"";
//    @property(nonatomic,strong) RERadioItem *requirement_status;//客源状态
    value = @"";
    value = self.requirement_status.value;
    value = [self DicValueFromValue:value AndDic:self.requirementDictList];
    [dic setValue:value forKey:@"requirement_status"];
    
//    @property(nonatomic,strong) RETextItem *client_name;//客户姓名
    value = @"";
    value = self.client_name.value;
    [dic setValue:value forKey:@"client_name"];
    
    
    
//    @property(nonatomic,strong) RERadioItem *client_gender;//客户性别
    value = @"";
    value = self.client_gender.value;
    value = [self DicValueFromValue:value AndDic:self.sex_dic_arr];
    [dic setValue:value forKey:@"client_gender"];
    
    
//    @property(nonatomic,strong) RERadioItem *client_level;//客户等级
    value = @"";
    value = self.client_level.value;
    value = [self DicValueFromValue:value AndDic:self.client_level_dic_arr];
    [dic setValue:value forKey:@"client_level"];
    
    
//    @property(nonatomic,strong) RERadioItem *client_background;//客户类别
    value = @"";
    value = self.client_level.value;
    value = [self DicValueFromValue:value AndDic:self.client_type_dic_arr];
    [dic setValue:value forKey:@"client_background"];
    
//    @property(nonatomic,strong) RETextItem *mobilePhone;//手机
    value = @"";
    value = self.mobilePhone.value;
    [dic setValue:value forKey:@"mobilePhone"];
//    @property(nonatomic,strong) RETextItem *fixPhone;//固话
    value = @"";
    value = self.fixPhone.value;
    [dic setValue:value forKey:@"fixPhone"];
//    @property(nonatomic,strong) RETextItem *idCardNO;//身份证
    value = @"";
    value = self.idCardNO.value;
    [dic setValue:value forKey:@"idCardNO"];
//    @property(nonatomic,strong) RETextItem *homeAddress;//家庭地址
    value = @"";
    value = self.homeAddress.value;
    [dic setValue:value forKey:@"homeAddress"];

    
//    @property(nonatomic,strong) RERadioItem *requirement_house_urban;//所属城区编号
    value = @"";
    value = self.requirement_house_urban.value;
    for (NSInteger i = 0; i < self.areaDictList.count; i++)
    {
       NSString*areaName = [[[self.areaDictList objectAtIndex:i] objectForKey:@"dict"] objectForKey:@"areas_name"];
        if ([areaName isEqualToString:value])
        {
            value = [[[self.areaDictList objectAtIndex:i] objectForKey:@"dict"] objectForKey:@"areas_type"];
        }
    }
    [dic setValue:value forKey:@"requirement_house_urban"];
    
    
//    @property(nonatomic,strong) RERadioItem *requirement_house_area;//所属片区编号
    value = @"";
    value = self.requirement_house_area.value;
    NSDictionary*dstDict = nil;
    for (NSDictionary *areaDict in self.areaDictList)
    {
        if ([[[areaDict objectForKey:@"dict"] objectForKey:@"areas_name"] isEqualToString:self.requirement_house_urban.value])
        {
            dstDict = areaDict;
            break;
        }
    }
    if (dstDict && dstDict.count > 0)
    {
        for (NSInteger i = 0; i < dstDict.count; i++)
        {
            if ([[[[dstDict objectForKey:@"sections"] objectAtIndex:i] objectForKey:@"areas_name"] isEqualToString:value])
            {
                value = [[[dstDict objectForKey:@"sections"] objectAtIndex:i] objectForKey:@"areas_type"];
            }
        }
    }

    [dic setValue:value forKey:@"requirement_house_area"];
    
    
//    @property(nonatomic,strong) RERadioItem *buildings_name;//楼盘编号
    value = @"";
    if (self.curBuildings)
    {
        value = self.curBuildings.buildings_dict_no;
    }
    [dic setValue:value forKey:@"buildings_name"];
    
//    @property(nonatomic,strong) RERadioItem *requirement_tene_application;//物业用途
    value = @"";
    value = self.requirement_tene_application.value;
    value = [self DicValueFromValue:value AndDic:self.tene_application_dic_arr];
    [dic setValue:value forKey:@"requirement_tene_application"];
    
//    @property(nonatomic,strong) RERadioItem *requirement_tene_type;//物业类型
    value = @"";
    value = self.requirement_tene_type.value;
    value = [self DicValueFromValue:value AndDic:self.tene_type_dic_arr];
    [dic setValue:value forKey:@"requirement_tene_type"];
    
//    @property(nonatomic,strong) RERadioItem *requirement_fitment_type;//装修类型
    value = @"";
    value = self.requirement_fitment_type.value;
    value = [self DicValueFromValue:value AndDic:self.fitment_type_dic_arr];
    [dic setValue:value forKey:@"requirement_fitment_type"];
    
//    @property(nonatomic,strong) RERadioItem *requirement_house_driect;//朝向
    value = @"";
    value = self.requirement_house_driect.value;
    value = [self DicValueFromValue:value AndDic:self.house_driect_dic_arr];
    [dic setValue:value forKey:@"requirement_house_driect"];
    
    
//    @property(nonatomic,strong) RENumberItem *requirement_floor_from;//Int最低楼层要求
    value = @"";
    value = self.requirement_floor_from.value;
    [dic setValue:value forKey:@"requirement_floor_from"];
    
    
//    @property(nonatomic,strong) RENumberItem *requirement_floor_to;//Int最高楼层要求
    value = @"";
    value = self.requirement_floor_to.value;
    [dic setValue:value forKey:@"requirement_floor_to"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_room_from;//Int最少卧室数量 要求
    value = @"";
    value = self.requirement_room_from.value;
    [dic setValue:value forKey:@"requirement_room_from"];
    
    
//    @property(nonatomic,strong) RENumberItem *requirement_room_to;//Int最大卧室数量 要求
    value = @"";
    value = self.requirement_room_to.value;
    [dic setValue:value forKey:@"requirement_room_to"];
    
    
//    @property(nonatomic,strong) RENumberItem *requirement_hall_from;//Int最少厅数量要 求
    value = @"";
    value = self.requirement_hall_from.value;
    [dic setValue:value forKey:@"requirement_hall_from"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_hall_to;//Int最大厅数量要 求
    value = @"";
    value = self.requirement_hall_to.value;
    [dic setValue:value forKey:@"requirement_hall_to"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_area_from;//最小面积要求
    value = @"";
    value = self.requirement_area_from.value;
    [dic setValue:value forKey:@"requirement_area_from"];
    
    
//    @property(nonatomic,strong) RENumberItem *requirement_area_to;//String最大面积要求
    value = @"";
    value = self.requirement_area_to.value;
    [dic setValue:value forKey:@"requirement_area_to"];
    
    
//    @property(nonatomic,strong) RERadioItem *requirement_client_source;//String客户来源
    value = @"";
    value = self.requirement_client_source.value;
    value = [self DicValueFromValue:value AndDic:self.client_source_dic_arr];
    [dic setValue:value forKey:@"requirement_client_source"];
    
//    
//    
//    @property(nonatomic,strong) RERadioItem *business_requirement_type;//求租或求购
    value = @"";
    value = self.business_requirement_type.value;
    
    for (NSDictionary*dic in self.trade_type_dic_arr)
    {
        id vl = [dic objectForKey:value];
        if (vl)
        {
            value = vl;
            break;
        }
    }
    
    [dic setValue:value forKey:@"business_requirement_type"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_sale_price_from;//String//￼最低求购价格
    value = @"";
    value = self.requirement_sale_price_from.value;
    [dic setValue:value forKey:@"requirement_sale_price_from"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_sale_price_to;//最高求购价格
    value = @"";
    value = self.requirement_sale_price_to.value;
    [dic setValue:value forKey:@"requirement_sale_price_to"];
    
//    @property(nonatomic,strong) RERadioItem *sale_price_unit;//求购价格单位
    value = @"";
    value = self.sale_price_unit.value;
    value = [self DicValueFromValue:value AndDic:self.sale_price_unit_dic_arr];
    [dic setValue:value forKey:@"sale_price_unit"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_lease_price_from;//最低求租价格
    value = @"";
    value = self.requirement_lease_price_from.value;
    [dic setValue:value forKey:@"requirement_lease_price_from"];
    
//    @property(nonatomic,strong) RENumberItem *requirement_lease_price_to;//最高求租价格
    value = @"";
    value = self.requirement_lease_price_to.value;
    [dic setValue:value forKey:@"requirement_lease_price_to"];
    
//    @property(nonatomic,strong) RERadioItem *lease_price_unit;//求租价格单位
    value = @"";
    value = self.lease_price_unit.value;
    value = [self DicValueFromValue:value AndDic:self.lease_price_unit_dic_arr];
    [dic setValue:value forKey:@"lease_price_unit"];
//    
//    @property(nonatomic,strong) RETextItem *requirement_memo;//备注
    value = @"";
    value = self.requirement_memo.value;
    [dic setValue:value forKey:@"requirement_memo"];
//    
//    @property(nonatomic,strong) RERadioItem *name_full;//置业顾问名字
    value = @"";
    if (self.curPerson)
    {
        value = self.curPerson.job_no;
    }
    [dic setValue:value forKey:@"name_full"];
    [self submit:dic];
}

-(void)submit:(NSDictionary*)dic
{
    SHOWHUD_WINDOW;
    
    [CustomerDataPuller pullAddCustomer:dic Success:^(id obj) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"继续添加" style:UIBarButtonItemStylePlain target:self action:@selector(addAgain:)];
        HIDEHUD_WINDOW;
        PRESENTALERT(@"添加成功", nil, nil, nil);
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW;
        PRESENTALERT(@"添加失败", error.localizedDescription, nil, nil);
    }];
    
}

-(void)addAgain:(id)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sumitBtnClicked:)];
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
    
    __typeof (&*self) __weak weakSelf = self;
    
    
//    @property(nonatomic,strong) RERadioItem *requirement_status;//客源状态
    self.requirement_status = [[RERadioItem alloc] initWithTitle:@"客源状态" value:@"" selectionHandler:^(RERadioItem *item) {
        
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.requirementDictList.count; i++)
        {
            DicItem *di = [self.requirementDictList objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerBaseInfoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    [self.customerBaseInfoSection addItem:self.requirement_status];
    
//    @property(nonatomic,strong) RETextItem *client_name;//客户姓名
    self.client_name = [[RETextItem alloc] initWithTitle:@"客户姓名" value:@""];
    [self.customerBaseInfoSection addItem:self.client_name];
    
//    @property(nonatomic,strong) RERadioItem *client_gender;//客户性别
    self.client_gender = [[RERadioItem alloc] initWithTitle:@"性别" value:@"" selectionHandler:^(RERadioItem *item) {
        
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.sex_dic_arr.count; i++)
        {
            DicItem *di = [self.sex_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerBaseInfoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    [self.customerBaseInfoSection addItem:self.client_gender];
    
//    @property(nonatomic,strong) RERadioItem *client_level;//客户等级
    self.client_level = [[RERadioItem alloc] initWithTitle:@"客户等级" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.client_level_dic_arr.count; i++)
        {
            DicItem *di = [self.client_level_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerBaseInfoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.customerBaseInfoSection addItem:self.client_level];
    
    
//    @property(nonatomic,strong) RERadioItem *client_background;//客户类别
    self.client_background = [[RERadioItem alloc] initWithTitle:@"客户类别" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.client_type_dic_arr.count; i++)
        {
            DicItem *di = [self.client_type_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerBaseInfoSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
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
    __typeof (&*self) __weak weakSelf = self;
    
    //    @property(nonatomic,strong) RERadioItem *requirement_house_urban;//所属城区编号
    self.requirement_house_urban = [[RERadioItem alloc] initWithTitle:@"需求城区" value:@"" selectionHandler:^(RERadioItem *item) {
        
        if (!self.areaDictList || self.areaDictList.count <= 0)
        {
            SHOWHUD_WINDOW;
            [HouseDataPuller pullAreaListDataSuccess:^(NSArray *areaList)
             {
                 HIDEHUD_WINDOW;
                 self.areaDictList = areaList;
                 [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                 NSMutableArray *options = [[NSMutableArray alloc] init];
                 for (NSInteger i = 0; i < self.areaDictList.count; i++)
                 {
                     [options addObject:[[[self.areaDictList objectAtIndex:i] objectForKey:@"dict"] objectForKey:@"areas_name"]];
                 }
                 RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                    {
                                                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                        [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                                        self.requirement_house_area.value = @"";
                                                                        [self.tableView reloadData];
                                                                    }];
                 // Adjust styles
                 optionsController.delegate = weakSelf;
                 optionsController.style = self.customerRequireSection.style;
                 if (weakSelf.tableView.backgroundView == nil)
                 {
                     optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                     optionsController.tableView.backgroundView = nil;
                 }
                 // Push the options controller
                 [weakSelf.navigationController pushViewController:optionsController animated:YES];
             }
                                             failure:^(NSError *error)
             {
                 HIDEHUD_WINDOW;
             }];
        }
        else
        {
            [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
            NSMutableArray *options = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < self.areaDictList.count; i++)
            {
                [options addObject:[[[self.areaDictList objectAtIndex:i] objectForKey:@"dict"] objectForKey:@"areas_name"]];
            }
            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                               {
                                                                   [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                   [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; // same
                                                                   self.requirement_house_area.value = @"";
                                                                   [self.tableView reloadData];
                                                               }];
            // Adjust styles
            optionsController.delegate = weakSelf;
            optionsController.style = self.customerRequireSection.style;
            if (weakSelf.tableView.backgroundView == nil)
            {
                optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                optionsController.tableView.backgroundView = nil;
            }
            // Push the options controller
            [weakSelf.navigationController pushViewController:optionsController animated:YES];
        }
        
        
        
        
    }];
    [self.customerRequireSection addItem:self.requirement_house_urban];
    
    //    @property(nonatomic,strong) RERadioItem *requirement_house_area;//所属片区编号
    self.requirement_house_area = [[RERadioItem alloc] initWithTitle:@"需求片区" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        NSDictionary *dstDict = nil;
        for (NSDictionary *areaDict in self.areaDictList)
        {
            if ([[[areaDict objectForKey:@"dict"] objectForKey:@"areas_name"] isEqualToString:self.requirement_house_urban.value])
            {
                dstDict = areaDict;
                break;
            }
        }
        if (dstDict && dstDict.count > 0)
        {
            for (NSInteger i = 0; i < dstDict.count; i++)
            {
                [options addObject:[[[dstDict objectForKey:@"sections"] objectAtIndex:i] objectForKey:@"areas_name"]];
            }
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerRequireSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.customerRequireSection addItem:self.requirement_house_area];
    
    
    //    @property(nonatomic,strong) RERadioItem *buildings_name;//楼盘编号
    self.buildings_name = [[RERadioItem alloc] initWithTitle:@"楼盘编号" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        BuildingsSelectTableViewController*selCtrl = [BuildingsSelectTableViewController initWithDelegate:weakSelf AndCompleteHandler:^(buildings *bld) {
            if (bld)
            {
                self.curBuildings = bld;
                self.buildings_name.value = bld.buildings_name;
                [self.tableView reloadData];
                [item reloadRowWithAnimation:UITableViewRowAnimationLeft];
            }
            
        }];
        
        [weakSelf.navigationController pushViewController:selCtrl animated:YES];
    }];
    [self.customerRequireSection addItem:self.buildings_name];
    
    
    //    @property(nonatomic,strong) RERadioItem *requirement_tene_application;//物业用途
    self.requirement_tene_application = [[RERadioItem alloc] initWithTitle:@"物业用途" value:@"" selectionHandler:^(RERadioItem *item) {
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
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft];

                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerRequireSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.customerRequireSection addItem:self.requirement_tene_application];
    
    //    @property(nonatomic,strong) RERadioItem *requirement_tene_type;//物业类型
    self.requirement_tene_type = [[RERadioItem alloc] initWithTitle:@"物业类型" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.tene_type_dic_arr.count; i++)
        {
            DicItem *di = [self.tene_type_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; // same
                                                           }];
        // Adjust styles
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerRequireSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        // Push the options controller
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.customerRequireSection addItem:self.requirement_tene_type];
    
    
    //    @property(nonatomic,strong) RERadioItem *requirement_fitment_type;//装修类型
    self.requirement_fitment_type = [[RERadioItem alloc] initWithTitle:@"装修类型" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.fitment_type_dic_arr.count; i++)
        {
            DicItem *di = [self.fitment_type_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerRequireSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.customerRequireSection addItem:self.requirement_fitment_type];
    
    
    //    @property(nonatomic,strong) RERadioItem *requirement_house_driect;//朝向
    self.requirement_house_driect = [[RERadioItem alloc] initWithTitle:@"朝向" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.house_driect_dic_arr.count; i++)
        {
            DicItem *di = [self.house_driect_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerRequireSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
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
    self.requirement_area_from.keyboardType = UIKeyboardTypeDecimalPad;
    
    //    @property(nonatomic,strong) RENumberItem *requirement_area_to;//String最大面积要求
    self.requirement_area_to = [[RENumberItem alloc] initWithTitle:@"最大面积要求" value:@""];
    [self.customerRequireSection addItem:self.requirement_area_to];
    
    //    @property(nonatomic,strong) RERadioItem *requirement_client_source;//String客户来源
    self.requirement_client_source = [[RERadioItem alloc] initWithTitle:@"客户来源" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.client_source_dic_arr.count; i++)
        {
            DicItem *di = [self.client_source_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.customerRequireSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.customerRequireSection addItem:self.requirement_client_source];
    
}

-(void)createTradeTypeItems
{
    __typeof (&*self) __weak weakSelf = self;
    //    @property(nonatomic,strong) RENumberItem *requirement_sale_price_from;//String//￼最低求购价格
    self.requirement_sale_price_from = [[RENumberItem alloc] initWithTitle:@"最低求购价格" value:@""];
   
    
    //    @property(nonatomic,strong) RENumberItem *requirement_sale_price_to;//最高求购价格
    self.requirement_sale_price_to = [[RENumberItem alloc] initWithTitle:@"最高求购价格" value:@""];
    
    
    //    @property(nonatomic,strong) RERadioItem *sale_price_unit;//求购价格单位
    self.sale_price_unit = [[RERadioItem alloc] initWithTitle:@"求购价格单位" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.sale_price_unit_dic_arr.count; i++)
        {
            DicItem *di = [self.sale_price_unit_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.tradeTypeSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    
    
    
    //    @property(nonatomic,strong) RENumberItem *requirement_lease_price_from;//最低求租价格
    self.requirement_lease_price_from = [[RENumberItem alloc] initWithTitle:@"最低求租价格" value:@""];
    
    
    //    @property(nonatomic,strong) RENumberItem *requirement_lease_price_to;//最高求租价格
    self.requirement_lease_price_to = [[RENumberItem alloc] initWithTitle:@"最高求租价格" value:@""];
    
    
    //    @property(nonatomic,strong) RERadioItem *lease_price_unit;//求租价格单位
    self.lease_price_unit = [[RERadioItem alloc] initWithTitle:@"求租价格单位" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.lease_price_unit_dic_arr.count; i++)
        {
            DicItem *di = [self.lease_price_unit_dic_arr objectAtIndex:i];
            [options addObject:di.dict_label];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft]; //
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.tradeTypeSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    
    //    @property(nonatomic,strong) RERadioItem *business_requirement_type;//求租或求购
    self.business_requirement_type = [[RERadioItem alloc] initWithTitle:@"租购" value:@"求购" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES];
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.trade_type_dic_arr.count; i++)
        {
            NSDictionary*dic = [self.trade_type_dic_arr objectAtIndex:i];
            [options addObjectsFromArray:[dic allKeys]];
        }
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                           {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               [item reloadRowWithAnimation:UITableViewRowAnimationLeft];
                                                               [self adjustItemsByTradeType:item.value];
                                                           }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.tradeTypeSection.style;
        if (weakSelf.tableView.backgroundView == nil)
        {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [self.tradeTypeSection addItem:self.business_requirement_type];
     [self.tradeTypeSection addItem:self.requirement_sale_price_from];
    [self.tradeTypeSection addItem:self.requirement_sale_price_to];
    [self.tradeTypeSection addItem:self.sale_price_unit];
}

-(void)createOtherItems
{
    __typeof (&*self) __weak weakSelf = self;
    //    @property(nonatomic,strong) RETextItem *requirement_memo;//备注
    self.requirement_memo = [[RETextItem alloc] initWithTitle:@"备注" value:@""];
    [self.remarkSection addItem:self.requirement_memo];
    
    
    
    //    @property(nonatomic,strong) RERadioItem *name_full;//置业顾问名字
    self.name_full = [[RERadioItem alloc] initWithTitle:@"置业顾问" value:@"" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        ContactListTableViewController *vc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] instantiateViewControllerWithIdentifier:@"ContactListTableViewController" AndClass:[ContactListTableViewController class]];
        vc.selectMode = YES;
        vc.singleSelect = YES;
        vc.selectResultDelegate = self;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.staffSection addItem:self.name_full];
}

-(void)returnSelection:(NSArray*)curSelection
{
    person *p = [curSelection lastObject];
    if (!p || ![p isKindOfClass:[person class]])
    {
        self.curPerson = nil;
        return;
    }
    self.name_full.value = p.name_full;
    self.curPerson = p;
    [self.name_full reloadRowWithAnimation:(UITableViewRowAnimationLeft)];
}

-(void)adjustItemsByTradeType:(NSString*)tradeType
{
    self.requirement_sale_price_from.value = @"";
    self.requirement_sale_price_to.value = @"";
    self.sale_price_unit.value = @"";
    self.requirement_lease_price_from.value = @"";
    self.requirement_lease_price_to.value = @"";
    self.lease_price_unit.value = @"";
    
    [self.tradeTypeSection removeItem:self.requirement_sale_price_from];
    [self.tradeTypeSection removeItem:self.requirement_sale_price_to];
    [self.tradeTypeSection removeItem:self.sale_price_unit];
    [self.tradeTypeSection removeItem:self.requirement_lease_price_from];
    [self.tradeTypeSection removeItem:self.requirement_lease_price_to];
    [self.tradeTypeSection removeItem:self.lease_price_unit];
    
    if ([tradeType isEqualToString:@"求购"])
    {
        [self.tradeTypeSection addItem:self.requirement_sale_price_from];
        [self.tradeTypeSection addItem:self.requirement_sale_price_to];
        [self.tradeTypeSection addItem:self.sale_price_unit];

    }
    else if([tradeType isEqualToString:@"求租"])
    {
        [self.tradeTypeSection addItem:self.requirement_lease_price_from];
        [self.tradeTypeSection addItem:self.requirement_lease_price_to];
        [self.tradeTypeSection addItem:self.lease_price_unit];
    }
    else if([tradeType isEqualToString:@"租购"])
    {
        [self.tradeTypeSection addItem:self.requirement_sale_price_from];
        [self.tradeTypeSection addItem:self.requirement_sale_price_to];
        [self.tradeTypeSection addItem:self.sale_price_unit];
        [self.tradeTypeSection addItem:self.requirement_lease_price_from];
        [self.tradeTypeSection addItem:self.requirement_lease_price_to];
        [self.tradeTypeSection addItem:self.lease_price_unit];
    }
    
    [self.tableView reloadData];
}

-(void)initDic
{
    self.tene_application_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_APPLICATION];
    self.tene_type_dic_arr = [dictionaryManager getItemArrByType:DIC_TENE_TYPE];
    self.fitment_type_dic_arr = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.house_driect_dic_arr = [dictionaryManager getItemArrByType:DIC_HOUSE_DIRECT_TYPE];
    self.use_situation_dic_arr = [dictionaryManager getItemArrByType:DIC_USE_SITUATION_TYPE];
    self.client_source_dic_arr = [dictionaryManager getItemArrByType:DIC_CLIENT_SOURCE_TYPE];
    self.look_permit_dic_arr = [dictionaryManager getItemArrByType:DIC_LOOK_PERMIT_TYPE];
    
    self.shop_rank_dic_arr = [dictionaryManager getItemArrByType:DIC_SHOP_RANK_TYPE];
    self.office_rank_dic_arr = [dictionaryManager getItemArrByType:DIC_OFFICE_RANK_TYPE];
    self.carport_rank_dic_arr = [dictionaryManager getItemArrByType:DIC_CARPORT_RANK_TYPE];
    self.sex_dic_arr = [dictionaryManager getItemArrByType:DIC_SEX_TYPE];
    self.requirementDictList = [dictionaryManager getItemArrByType:DIC_REQUIREMENT_STATE];
    self.client_level_dic_arr = [dictionaryManager getItemArrByType:DIC_CLIENT_LEVEL];
    self.client_type_dic_arr = [dictionaryManager getItemArrByType:DIC_CLIENT_BG];
    self.trade_type_dic_arr =  @[
                                 @{@"求购":@"200"},
                                 @{@"求租": @"201"},
                                 @{@"租购": @"202"}
                                 ];
    self.sale_price_unit_dic_arr = [dictionaryManager getItemArrByType:DIC_SALE_PRICE_UNIT_TYPE];
    self.lease_price_unit_dic_arr = [dictionaryManager getItemArrByType:DIC_LEASE_PRICE_UNIT_TYPE];
}

@end
