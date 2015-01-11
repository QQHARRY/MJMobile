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
@property (strong, readwrite, nonatomic) RETextItem *customerItem;



@property (strong, readwrite, nonatomic) RERadioItem *typeItem;
@property (strong, readwrite, nonatomic) RERadioItem *consignItem;
@property (strong, readwrite, nonatomic) RERadioItem *payItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *startItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *endItem;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@end

@implementation SignAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"预约签约";
    
    // 客户》日期》签约室》时段》签约人
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.signSection = [self addSignControls];
    self.commitSection = [self addCommitButton];
}

- (RETableViewSection *)addSignControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"签约信息"];
    [self.manager addSection:section];
    self.customerItem = [RETextItem itemWithTitle:@"客户" value:nil placeholder:@"请输入客户ID"];
    [section addItem:self.customerItem];
    
//    self.typeItem = [RERadioItem itemWithTitle:@"交易类型" value:@"" selectionHandler:^(RERadioItem *item)
//                     {
//                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
//                         NSMutableArray *options = [[NSMutableArray alloc] init];
//                         for (NSInteger i = 0; i < self.typeDictList.count; i++)
//                         {
//                             DicItem *di = [self.typeDictList objectAtIndex:i];
//                             [options addObject:di.dict_label];
//                         }
//                         RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
//                                                                            {
//                                                                                [weakSelf.navigationController popViewControllerAnimated:YES];
//                                                                                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                                                                            }];
//                         // Adjust styles
//                         optionsController.delegate = weakSelf;
//                         optionsController.style = section.style;
//                         if (weakSelf.tableView.backgroundView == nil)
//                         {
//                             optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
//                             optionsController.tableView.backgroundView = nil;
//                         }
//                         // Push the options controller
//                         [weakSelf.navigationController pushViewController:optionsController animated:YES];
//                     }];
//    [section addItem:self.typeItem];
//    self.consignItem = [RERadioItem itemWithTitle:@"委托类型" value:@"" selectionHandler:^(RERadioItem *item)
//                     {
//                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
//                         NSMutableArray *options = [[NSMutableArray alloc] init];
//                         for (NSInteger i = 0; i < self.consignDictList.count; i++)
//                         {
//                             DicItem *di = [self.consignDictList objectAtIndex:i];
//                             [options addObject:di.dict_label];
//                         }
//                         RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
//                                                                            {
//                                                                                [weakSelf.navigationController popViewControllerAnimated:YES];
//                                                                                [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                                                                            }];
//                         // Adjust styles
//                         optionsController.delegate = weakSelf;
//                         optionsController.style = section.style;
//                         if (weakSelf.tableView.backgroundView == nil)
//                         {
//                             optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
//                             optionsController.tableView.backgroundView = nil;
//                         }
//                         // Push the options controller
//                         [weakSelf.navigationController pushViewController:optionsController animated:YES];
//                     }];
//    [section addItem:self.consignItem];
//    self.payItem = [RERadioItem itemWithTitle:@"付佣类型" value:@"" selectionHandler:^(RERadioItem *item)
//                        {
//                            [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
//                            NSMutableArray *options = [[NSMutableArray alloc] init];
//                            for (NSInteger i = 0; i < self.payDictList.count; i++)
//                            {
//                                DicItem *di = [self.payDictList objectAtIndex:i];
//                                [options addObject:di.dict_label];
//                            }
//                            RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem)
//                                                                               {
//                                                                                   [weakSelf.navigationController popViewControllerAnimated:YES];
//                                                                                   [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                                                                               }];
//                            // Adjust styles
//                            optionsController.delegate = weakSelf;
//                            optionsController.style = section.style;
//                            if (weakSelf.tableView.backgroundView == nil)
//                            {
//                                optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
//                                optionsController.tableView.backgroundView = nil;
//                            }
//                            // Push the options controller
//                            [weakSelf.navigationController pushViewController:optionsController animated:YES];
//                        }];
//    [section addItem:self.payItem];
//    self.startItem = [REDateTimeItem itemWithTitle:@"委托开始日期" value:nil placeholder:nil format:@"MM/dd/yyyy hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
//    [section addItem:self.startItem];
//    self.endItem = [REDateTimeItem itemWithTitle:@"委托结束日期" value:nil placeholder:nil format:@"MM/dd/yyyy hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
//    [section addItem:self.endItem];

    return section;
}

- (RETableViewSection *)addCommitButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"提交" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
    {
//        NSMutableDictionary *param = [NSMutableDictionary dictionary];
//        [param setValue:[person me].job_no forKey:@"job_no"];
//        [param setValue:[person me].password forKey:@"acc_password"];
//        [param setValue:[UtilFun getUDID] forKey:@"DeviceID"];
//        [param setValue:self.sid forKey:@"Sign_target_object"];
//        if (!self.typeItem.value || self.typeItem.value.length <= 0)
//        {
//            PRSENTALERT(@"错 误", @"请选择交易类型", @"O K", self);
//            return;
//        }
//        for (DicItem *di in self.typeDictList)
//        {
//            if ([di.dict_label isEqualToString:self.typeItem.value])
//            {
//                [param setValue:di.dict_value forKey:@"trade_type"];
//                break;
//            }
//        }
//        if (!self.consignItem.value || self.consignItem.value.length <= 0)
//        {
//            PRSENTALERT(@"错 误", @"请选择委托类型", @"O K", self);
//            return;
//        }
//        for (DicItem *di in self.consignDictList)
//        {
//            if ([di.dict_label isEqualToString:self.consignItem.value])
//            {
//                [param setValue:di.dict_value forKey:@"Sign_type"];
//                break;
//            }
//        }
//        if (!self.payItem.value || self.payItem.value.length <= 0)
//        {
//            PRSENTALERT(@"错 误", @"请选择付佣类型", @"O K", self);
//            return;
//        }
//        for (DicItem *di in self.payDictList)
//        {
//            if ([di.dict_label isEqualToString:self.payItem.value])
//            {
//                [param setValue:di.dict_value forKey:@"Sign_pay_sort"];
//                break;
//            }
//        }
//        if (!self.startItem.value)
//        {
//            PRSENTALERT(@"错 误", @"请选择委托开始日期", @"O K", self);
//            return;
//        }
//        [param setValue:self.startItem.value forKey:@"Sign_start_date"];
//        if (!self.endItem.value)
//        {
//            PRSENTALERT(@"错 误", @"请选择委托结束日期", @"O K", self);
//            return;
//        }
//        [param setValue:self.endItem.value forKey:@"Sign_end_date"];
//        SHOWHUD_WINDOW;
//        [SignDataPuller pushNewSignWithParam:param Success:^(NSString *att)
//        {
//            HIDEHUD_WINDOW;
//            PRSENTALERT(@"提交成功", @"请立刻上传附件", @"O K", self);
//        }
//                                         failure:^(NSError *error)
//        {
//            HIDEHUD_WINDOW;
//            PRSENTALERT(@"提交错误", @"可能是网络问题，请稍候再试", @"O K", self);
//            return;
//        }];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}

@end
