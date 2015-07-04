//
//  FollowAddController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "FollowAddController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "FollowDataPuller.h"
#import "UtilFun.h"
#import "person.h"
#import "dictionaryManager.h"


@interface FollowAddController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;


@property (strong, readwrite, nonatomic)RETableViewSection*houseSecretInfoSection;
@property (strong, readwrite, nonatomic) ReMultiTextItem *addressDetails;
@property (strong, readwrite, nonatomic) RETableViewItem *mobileNo;
@property (strong, readwrite, nonatomic) RETextItem *client_nameAndClient_identity;
@property (strong, readwrite, nonatomic) RETextItem *client_gender;
@property (strong,nonatomic)NSArray*genderDicList;




@property (strong, readwrite, nonatomic) RETableViewSection *followSection;
@property (strong, readwrite, nonatomic) RERadioItem *typeItem;
@property (strong, readwrite, nonatomic) RERadioItem *saleStatusItem;
@property (strong, readwrite, nonatomic) RERadioItem *rentStatusItem;
@property (strong, readwrite, nonatomic) RERadioItem *requireStatusItem;
@property (strong, readwrite, nonatomic) RELongTextItem *contentItem;

@property (strong, readwrite, nonatomic) RETableViewSection *remindSection;
@property (strong, readwrite, nonatomic) REBoolItem *remindItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *timeItem;
@property (strong, readwrite, nonatomic) RERadioItem *rangeItem;
@property (strong, readwrite, nonatomic) RELongTextItem *rcontentItem;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) NSArray *followDictList; // follow_task_type
@property (nonatomic, strong) NSArray *leaseDictList;
@property (nonatomic, strong) NSArray *saleDictList;
@property (nonatomic, strong) NSArray *requireDictList;

@property (nonatomic, strong) NSString*privLogNo;

@end

@implementation FollowAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加跟进";
    
    // get dict
    self.followDictList = [dictionaryManager getItemArrByType:DIC_FOLLOW_TASK_TYPE];
    self.leaseDictList = [dictionaryManager getItemArrByType:DIC_LEASE_TRADE_STATE];
    self.saleDictList = [dictionaryManager getItemArrByType:DIC_SALE_TRADE_STATE];
    self.requireDictList = [dictionaryManager getItemArrByType:DIC_REQUIREMENT_STATE];
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    if (self.followType == K_FOLLOW_TYPE_HOUSE)
    {
        [self getFollowCount];
    }
    else
    {
        [self addSections];
    }

    
}

-(void)addSections
{
    // add section
    [self addSecretInfoSection];
    self.followSection = [self addFollowControls];
    self.remindSection = [self addRemindControls];
    self.commitSection = [self addCommitButton];
}

-(void)getFollowCount
{
    SHOWWINDOWHUD(@"正在获取跟进号");
    [FollowDataPuller pullPrivLog:self.sid Success:^(NSString *privNo) {
        HIDEHUD_WINDOW
        if (privNo)
        {
            self.privLogNo = privNo;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addSections];
                [self.tableView reloadData];
            });
            
        }
        else
        {
            PRESENTALERT(@"获取跟进号失败,请重试.", @"", nil, nil, nil);
        }
        
    } failure:^(NSError *error) {
        HIDEHUD_WINDOW
        PRESENTALERT(@"获取跟进号失败,请重试.", @"", nil, nil, nil);
    }];
}

- (RETableViewSection *)addFollowControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"跟进信息"];
    [self.manager addSection:section];
    self.typeItem = [RERadioItem itemWithTitle:@"跟进方式" value:@"" selectionHandler:^(RERadioItem *item)
                     {
                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                         NSMutableArray *options = [[NSMutableArray alloc] init];
                         for (NSInteger i = 0; i < self.followDictList.count; i++)
                         {
                             DicItem *di = [self.followDictList objectAtIndex:i];
                             [options addObject:di.dict_label];
                         }
                         RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                            {
                                                                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                            }];
                         // Adjust styles
                         optionsController.delegate = weakSelf;
                         optionsController.style = section.style;
                         if (weakSelf.tableView.backgroundView == nil)
                         {
                             optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                             optionsController.tableView.backgroundView = nil;
                         }
                         // Push the options controller
                         [weakSelf.navigationController pushViewController:optionsController animated:YES];
                     }];
    [section addItem:self.typeItem];
    if ([self.type isEqualToString:@"出售"] || [self.type isEqualToString:@"租售"])
    {
        self.saleStatusItem = [RERadioItem itemWithTitle:@"出售状态" value:@"" selectionHandler:^(RERadioItem *item)
                               {
                                   [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                   NSMutableArray *options = [[NSMutableArray alloc] init];
                                   for (NSInteger i = 0; i < self.saleDictList.count; i++)
                                   {
                                       DicItem *di = [self.saleDictList objectAtIndex:i];
                                       [options addObject:di.dict_label];
                                   }
                                   RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                      {
                                                                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                      }];
                                   // Adjust styles
                                   optionsController.delegate = weakSelf;
                                   optionsController.style = section.style;
                                   if (weakSelf.tableView.backgroundView == nil)
                                   {
                                       optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                       optionsController.tableView.backgroundView = nil;
                                   }
                                   // Push the options controller
                                   [weakSelf.navigationController pushViewController:optionsController animated:YES];
                               }];
        [section addItem:self.saleStatusItem];
    }
    if ([self.type isEqualToString:@"出租"] || [self.type isEqualToString:@"租售"])
    {
        self.rentStatusItem = [RERadioItem itemWithTitle:@"出租状态" value:@"" selectionHandler:^(RERadioItem *item)
                               {
                                   [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                   NSMutableArray *options = [[NSMutableArray alloc] init];
                                   for (NSInteger i = 0; i < self.leaseDictList.count; i++)
                                   {
                                       DicItem *di = [self.leaseDictList objectAtIndex:i];
                                       [options addObject:di.dict_label];
                                   }
                                   RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                      {
                                                                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                      }];
                                   // Adjust styles
                                   optionsController.delegate = weakSelf;
                                   optionsController.style = section.style;
                                   if (weakSelf.tableView.backgroundView == nil)
                                   {
                                       optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                       optionsController.tableView.backgroundView = nil;
                                   }
                                   // Push the options controller
                                   [weakSelf.navigationController pushViewController:optionsController animated:YES];
                               }];
        [section addItem:self.rentStatusItem];
    }
    if ([self.type isEqualToString:@"求租"] || [self.type isEqualToString:@"求购"] || [self.type isEqualToString:@"租购"])
    {
        self.requireStatusItem = [RERadioItem itemWithTitle:@"客源状态" value:@"" selectionHandler:^(RERadioItem *item)
                               {
                                   [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                   NSMutableArray *options = [[NSMutableArray alloc] init];
                                   for (NSInteger i = 0; i < self.requireDictList.count; i++)
                                   {
                                       DicItem *di = [self.requireDictList objectAtIndex:i];
                                       [options addObject:di.dict_label];
                                   }
                                   RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                      {
                                                                                          [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                      }];
                                   // Adjust styles
                                   optionsController.delegate = weakSelf;
                                   optionsController.style = section.style;
                                   if (weakSelf.tableView.backgroundView == nil)
                                   {
                                       optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                       optionsController.tableView.backgroundView = nil;
                                   }
                                   // Push the options controller
                                   [weakSelf.navigationController pushViewController:optionsController animated:YES];
                               }];
        [section addItem:self.requireStatusItem];
    }
    [section addItem:@"跟进内容"];
    self.contentItem = [RELongTextItem itemWithValue:nil placeholder:@"请输入跟进内容"];
    self.contentItem.cellHeight = 100;
    [section addItem:self.contentItem];
    return section;
}

-(void)switchRemind:(BOOL)b
{
    if (b)
    {
        [self.remindSection addItem:self.timeItem];
        [self.remindSection addItem:self.rangeItem];
        [self.remindSection addItem:@"提醒内容"];
        [self.remindSection addItem:self.rcontentItem];
    }
    else
    {
        [self.remindSection removeItem:self.timeItem];
        [self.remindSection removeItem:self.rangeItem];
        [self.remindSection removeItem:@"提醒内容"];
        [self.remindSection removeItem:self.rcontentItem];
    }
    [self.tableView reloadData];
}

- (RETableViewSection *)addRemindControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"提醒"];
    [self.manager addSection:section];
    self.remindItem = [REBoolItem itemWithTitle:@"是否提醒" value:NO switchValueChangeHandler:^(REBoolItem *item)
    {
        [self switchRemind:item.value];
    }];
    [section addItem:self.remindItem];
    self.timeItem = [REDateTimeItem itemWithTitle:@"提醒日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    self.rangeItem = [RERadioItem itemWithTitle:@"提醒范围" value:@"" selectionHandler:^(RERadioItem *item)
                              {
                                  [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                  NSArray *options = @[@"本人", @"本部"];
                                  RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
                                                                                     {
                                                                                         [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                                         [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                     }];
                                  // Adjust styles
                                  optionsController.delegate = weakSelf;
                                  optionsController.style = section.style;
                                  if (weakSelf.tableView.backgroundView == nil)
                                  {
                                      optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
                                      optionsController.tableView.backgroundView = nil;
                                  }
                                  // Push the options controller
                                  [weakSelf.navigationController pushViewController:optionsController animated:YES];
                              }];
    self.rcontentItem = [RELongTextItem itemWithValue:nil placeholder:@"请输入提醒内容"];
    self.rcontentItem.cellHeight = 100;
    return section;
}

- (RETableViewSection *)addCommitButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"提交" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setValue:[person me].job_no forKey:@"job_no"];
        [param setValue:[person me].password forKey:@"acc_password"];
        [param setValue:[UtilFun getUDID] forKey:@"DeviceID"];
        [param setValue:self.sid forKey:@"task_obj_no"];
        if ([self.type isEqualToString:@"出售"])
        {
            [param setValue:@"100" forKey:@"trade_type"];
        }
        else if ([self.type isEqualToString:@"出租"])
        {
            [param setValue:@"101" forKey:@"trade_type"];
        }
        else if ([self.type isEqualToString:@"租售"])
        {
            [param setValue:@"102" forKey:@"trade_type"];
        }
        else if ([self.type isEqualToString:@"求租"])
        {
            [param setValue:@"201" forKey:@"trade_type"];
        }
        else if ([self.type isEqualToString:@"求购"])
        {
            [param setValue:@"200" forKey:@"trade_type"];
        }
        else if ([self.type isEqualToString:@"租购"])
        {
            [param setValue:@"202" forKey:@"trade_type"];
        }
        if (!self.typeItem.value || self.typeItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择跟进方式", @"O K", nil,self);
            return;
        }
        for (DicItem *di in self.followDictList)
        {
            if ([di.dict_label isEqualToString:self.typeItem.value])
            {
                [param setValue:di.dict_value forKey:@"task_type"];
                break;
            }
        }
        if ([self.type isEqualToString:@"出售"] || [self.type isEqualToString:@"租售"])
        {
            if (!self.saleStatusItem.value || self.saleStatusItem.value.length <= 0)
            {
                PRESENTALERT(@"错 误", @"请选择出售状态", @"O K",nil, self);
                return;
            }
            for (DicItem *di in self.saleDictList)
            {
                if ([di.dict_label isEqualToString:self.saleStatusItem.value])
                {
                    [param setValue:di.dict_value forKey:@"sale_trade_state"];
                    break;
                }
            }
        }
        if ([self.type isEqualToString:@"出租"] || [self.type isEqualToString:@"租售"])
        {
            if (!self.rentStatusItem.value || self.rentStatusItem.value.length <= 0)
            {
                PRESENTALERT(@"错 误", @"请选择出租状态", @"O K",nil, self);
                return;
            }
            for (DicItem *di in self.leaseDictList)
            {
                if ([di.dict_label isEqualToString:self.rentStatusItem.value])
                {
                    [param setValue:di.dict_value forKey:@"lease_trade_state"];
                    break;
                }
            }
        }
        if ([self.type isEqualToString:@"求租"] || [self.type isEqualToString:@"求购"] || [self.type isEqualToString:@"租购"])
        {
            if (!self.requireStatusItem.value || self.requireStatusItem.value.length <= 0)
            {
                PRESENTALERT(@"错 误", @"请选择客源状态", @"O K",nil, self);
                return;
            }
            for (DicItem *di in self.requireDictList)
            {
                if ([di.dict_label isEqualToString:self.requireStatusItem.value])
                {
                    [param setValue:di.dict_value forKey:@"requirement_status"];
                    break;
                }
            }
        }
        if (!self.contentItem.value || self.contentItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请输入跟进内容", @"O K",nil, self);
            return;
        }
        [param setValue:self.contentItem.value forKey:@"task_follow_content"];
        if (self.remindItem.value)
        {
            [param setValue:@"1" forKey:@"task_reminder_flg"];
            if (!self.rcontentItem.value || self.rcontentItem.value.length <= 0)
            {
                PRESENTALERT(@"错 误", @"请输入提醒内容", @"O K",nil, self);
                return;
            }
            [param setValue:self.rcontentItem.value forKey:@"task_reminder_content"];
            
            if (!self.timeItem.value)
            {
                PRESENTALERT(@"错 误", @"请选择提醒日期", @"O K",nil, self);
                return;
            }
            NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString* dateString = [fmt stringFromDate:self.timeItem.value];
            [param setValue:dateString forKey:@"task_reminder_date"];
            
            
            if (!self.rangeItem.value || self.rangeItem.value.length <= 0)
            {
                PRESENTALERT(@"错 误", @"请选择提醒范围", @"O K",nil, self);
                return;
            }
            [param setValue:([self.rangeItem.value isEqualToString:@"本人"] ? @"0" : @"1") forKey:@"task_reminder_range"];
        }
        else
        {
            [param setValue:@"0" forKey:@"task_reminder_flg"];
        }
        
        
        
        if (self.followType == K_FOLLOW_TYPE_HOUSE)
        {
            [param setValue:self.privLogNo forKey:@"priv_log_id"];
        }
        SHOWHUD_WINDOW;
        [FollowDataPuller pushNewFollowWithParam:param Success:^(NSString *followNo)
        {
            HIDEHUD_WINDOW;
            if ([followNo isEqualToString:@"E-1003"])
            {
                PRESENTALERT(@"提交错误", @"您没有新增该房源跟进的权限", @"O K", nil,self);
                return;
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
                                         failure:^(NSError *error)
        {
            HIDEHUD_WINDOW;
            PRESENTALERT(@"提交错误", @"可能是网络问题，请稍候再试", @"O K", nil,self);
            return;
        }];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}


-(void)addSecretInfoSection
{

    if (self.followType == K_FOLLOW_TYPE_HOUSE)
    {
        if(self.houseSecretPtcl && self.houseDtl && self.housePtcl)
        [self addHouseSecretInfoSection];
    }
    else
    {
        
    }
    
//    
//    @property (strong, readwrite, nonatomic)RETableViewSection*customerSecretInfoSection;
//    @property (strong, readwrite, nonatomic) RETextItem *customerMobileNo;
//    @property (strong, readwrite, nonatomic) RETextItem *customerFixNo;
//    @property (strong, readwrite, nonatomic) RETextItem *customerIDCardNo;
//    @property (strong, readwrite, nonatomic) ReMultiTextItem *customerAddress;
}

-(RETableViewSection*)addHouseSecretInfoSection
{
    //    @property (strong, readwrite, nonatomic)RETableViewSection*houseSecretInfoSection;
    //    @property (strong, readwrite, nonatomic) ReMultiTextItem *addressDetails;
    //    @property (strong, readwrite, nonatomic) RETextItem *mobileNo;
    //    @property (strong, readwrite, nonatomic) RETextItem *client_nameAndClient_identity;
    //    @property (strong, readwrite, nonatomic) RETextItem *client_gender;
    //
    self.houseSecretInfoSection = [[RETableViewSection alloc] initWithHeaderTitle:@"房源信息"];
    [self.manager addSection:self.houseSecretInfoSection];
    
    NSString*houseDetailAddr = @"";
    NSString*clientName = @"";
    NSString*clientMobile = @"";
    NSString*clientGender = @"";
    if (self.houseSecretPtcl && self.houseDtl && self.housePtcl)
    {
        houseDetailAddr = [NSString stringWithFormat:@"%@ %@%@单元%@号",self.houseDtl.domain_name,self.housePtcl.building_name,self.houseSecretPtcl.unit_name,self.houseSecretPtcl.house_tablet];
        
        clientName = [NSString stringWithFormat:@"%@",self.houseSecretPtcl.client_name];
        if (self.houseSecretPtcl.client_salutation != nil && self.houseSecretPtcl.client_salutation.length > 0)
        {
            clientName = [clientName stringByAppendingFormat:@"(%@)",self.houseSecretPtcl.client_salutation];
        }
        
        clientMobile = self.houseSecretPtcl.obj_mobile;
        


        if(self.genderDicList == nil)
        {
            self.genderDicList = [dictionaryManager getItemArrByType:DIC_SEX_TYPE];
        }
        for (DicItem *di in self.genderDicList)
        {
            if ([di.dict_value isEqualToString:self.houseSecretPtcl.client_gender])
            {
                clientGender = di.dict_label;
                break;
            }
        }
    }
    self.addressDetails = [[ReMultiTextItem alloc] initWithTitle:@"详细地址" value:houseDetailAddr];
    self.addressDetails.enabled = NO;
    [self.houseSecretInfoSection addItem:self.addressDetails];
    
    
    
    self.client_nameAndClient_identity = [[RETextItem alloc] initWithTitle:@"业主姓名(称呼)" value:clientName];
    self.client_nameAndClient_identity.enabled = NO;
    [self.houseSecretInfoSection addItem:self.client_nameAndClient_identity];

   
    self.client_gender = [[RETextItem alloc] initWithTitle:@"业主性别" value:clientGender];
    self.client_gender.enabled = NO;
    [self.houseSecretInfoSection addItem:self.client_gender];
    
    self.mobileNo = [RETableViewItem itemWithTitle:@"查看业主手机号" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
                           {
                               [item deselectRowAnimated:YES];
                               PRESENTALERT(@"", clientMobile, nil, nil,self);
                           }];
    
    
    self.mobileNo.textAlignment = NSTextAlignmentCenter;
    [self.houseSecretInfoSection addItem:self.mobileNo];
    
    return self.houseSecretInfoSection;
}

@end
