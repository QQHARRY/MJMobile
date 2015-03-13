//
//  SignAddController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "SignAddController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "SignDataPuller.h"
#import "UtilFun.h"
#import "person.h"

@interface SignAddController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *signSection;
//@property (strong, readwrite, nonatomic) RETextItem *customerItem;
@property (strong, readwrite, nonatomic) RERadioItem *customerItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *timeItem;
@property (strong, readwrite, nonatomic) RERadioItem *personItem;
@property (strong, readwrite, nonatomic) RERadioItem *roomItem;
@property (strong, readwrite, nonatomic) RERadioItem *secItem;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) NSArray *personList;
@property (nonatomic, strong) NSArray *roomList;
@property (nonatomic, strong) NSDictionary *client;

@end

@implementation SignAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"预约签约";
    
    // 客户》日期 》签约室》时段》签约人
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.signSection = [self addSignControls];
    self.commitSection = [self addCommitButton];
    
    // pull condition
    [self pullCondition];
}

-(void)pullCondition
{
    SHOWHUD_WINDOW;
    [SignDataPuller pullSignConditionListDataSuccess:^(NSDictionary *conditionSrc)
    {
        HIDEHUD_WINDOW;
        self.personList = [conditionSrc objectForKey:@"AllPersonNode"];
        self.roomList = [conditionSrc objectForKey:@"AllRoomNode"];
    }
                                             failure:^(NSError *error)
    {
        HIDEHUD_WINDOW;
    }];
}

- (RETableViewSection *)addSignControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"签约信息"];
    [self.manager addSection:section];
//    self.customerItem = [RETextItem itemWithTitle:@"客户" value:nil placeholder:@"请输入客户ID"];
//    [section addItem:self.customerItem];
    self.customerItem = [RERadioItem itemWithTitle:@"客户" value:@"" selectionHandler:^(RERadioItem *item)
                          {
                              [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                              ClientFilterController *vc = [[ClientFilterController alloc] initWithStyle:UITableViewStyleGrouped];
                              vc.delegate = self;
                              [weakSelf.navigationController pushViewController:vc animated:YES];
                          }];
    [section addItem:self.customerItem];
    self.timeItem = [REDateTimeItem itemWithTitle:@"签约日期" value:nil placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    [section addItem:self.timeItem];
    self.personItem = [RERadioItem itemWithTitle:@"签约人" value:@"" selectionHandler:^(RERadioItem *item)
                       {
                           [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                           NSMutableArray *options = [[NSMutableArray alloc] init];
                           for (NSInteger i = 0; i < self.personList.count; i++)
                           {
                               NSDictionary *d = [self.personList objectAtIndex:i];
                               [options addObject:[d objectForKey:@"person_name_full"]];
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
    [section addItem:self.personItem];
    self.roomItem = [RERadioItem itemWithTitle:@"签约室" value:@"" selectionHandler:^(RERadioItem *item)
                       {
                           [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                           NSMutableArray *options = [[NSMutableArray alloc] init];
                           for (NSInteger i = 0; i < self.roomList.count; i++)
                           {
                               NSDictionary *d = [self.roomList objectAtIndex:i];
                               [options addObject:[d objectForKey:@"room_name"]];
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
    [section addItem:self.roomItem];
    self.secItem = [RERadioItem itemWithTitle:@"签约时段" value:@"" selectionHandler:^(RERadioItem *item)
                     {
                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                         NSArray *options = @[@"09:00-10:00",
                                                     @"10:00-11:00",
                                                     @"11:00-12:00",
                                                     @"12:00-13:00",
                                                     @"13:00-14:00",
                                                     @"14:00-15:00",
                                                     @"15:00-16:00",
                                                     @"16:00-17:00",
                                                     @"17:00-18:00",
                                                     @"18:00-19:00",
                                                     @"19:00-20:00",
                                                     @"20:00-21:00"];
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
    [section addItem:self.secItem];

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
        [param setValue:self.sid forKey:@"house_trade_no"];
        if (!self.customerItem.value || self.customerItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择客户", @"O K", self);
            return;
        }
        [param setValue:self.customerItem.value forKey:@"client_base_no"];
        if (!self.personItem.value || self.personItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择签约人", @"O K", self);
            return;
        }
        for (NSDictionary *d in self.personList)
        {
            if ([[d objectForKey:@"person_name_full"] isEqualToString:self.personItem.value])
            {
                [param setValue:[d objectForKey:@"person_no"] forKey:@"person_no"];
                break;
            }
        }
        if (!self.roomItem.value || self.roomItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择签约室", @"O K", self);
            return;
        }
        for (NSDictionary *d in self.roomList)
        {
            if ([[d objectForKey:@"room_name"] isEqualToString:self.roomItem.value])
            {
                [param setValue:[d objectForKey:@"room_no"] forKey:@"room_no"];
                break;
            }
        }
        if (!self.timeItem.value)
        {
            PRESENTALERT(@"错 误", @"请选择签约日期", @"O K", self);
            return;
        }
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [param setValue:[dateFormatter stringFromDate:self.timeItem.value] forKey:@"apply_date"];
        }
        if (!self.secItem.value || self.secItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择签约时段", @"O K", self);
            return;
        }
        [param setValue:self.secItem.value forKey:@"apply_time"];
        SHOWHUD_WINDOW;
        [SignDataPuller pushNewSignWithParam:param Success:^(NSString *att)
        {
            HIDEHUD_WINDOW;
            if ([att isEqualToString:@"E-1003"])
            {
                PRESENTALERT(@"提交错误", @"您没有新增该房源跟进的权限", @"O K", self);
                return;
            }
            else if ([att isEqualToString:@"E-1001"])
            {
                PRESENTALERT(@"提交错误", @"新增预约有重复，添加失败", @"O K", self);
                return;
            }
            else
            {
                PRESENTALERTWITHHANDER(@"成功", @"预约签约成功！",@"OK", self, ^(UIAlertAction *action)
                                       {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       });
                return;
            }
        }
                                         failure:^(NSError *error)
        {
            HIDEHUD_WINDOW;
            PRESENTALERT(@"提交错误", @"可能是网络问题，请稍候再试", @"O K", self);
            return;
        }];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}

-(void)returnClientSelection:(NSDictionary *)client
{
    self.client = client;
    self.customerItem.value = [self.client objectForKey:@"client_name"];
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"成功"] && buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

