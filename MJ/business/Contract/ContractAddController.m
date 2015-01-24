//
//  ContractAddController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "ContractAddController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "ContractDataPuller.h"
#import "UtilFun.h"
#import "person.h"

@interface ContractAddController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *contractSection;
@property (strong, readwrite, nonatomic) RERadioItem *typeItem;
@property (strong, readwrite, nonatomic) RERadioItem *consignItem;
@property (strong, readwrite, nonatomic) RERadioItem *payItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *startItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *endItem;

@property (strong, readwrite, nonatomic) RETableViewSection *fileSection;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) NSArray *typeDictList;
@property (nonatomic, strong) NSArray *consignDictList;
@property (nonatomic, strong) NSArray *payDictList;

@end

@implementation ContractAddController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"添加委托";
    
    // get dict
    self.typeDictList = [dictionaryManager getItemArrByType:DIC_TRADE_TYPE];
    self.consignDictList = [dictionaryManager getItemArrByType:DIC_CONSIGNMENT_TYPE];
    self.payDictList = [dictionaryManager getItemArrByType:DIC_PAY_SORT];
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.contractSection = [self addContractControls];
    self.fileSection = [self addFileControls];
    self.commitSection = [self addCommitButton];
}

- (RETableViewSection *)addFileControls
{
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"附件信息"];
    [self.manager addSection:section];
    
    return section;
}

- (RETableViewSection *)addContractControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"委托信息"];
    [self.manager addSection:section];
    self.typeItem = [RERadioItem itemWithTitle:@"交易类型" value:@"" selectionHandler:^(RERadioItem *item)
                     {
                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                         NSMutableArray *options = [[NSMutableArray alloc] init];
                         for (NSInteger i = 0; i < self.typeDictList.count; i++)
                         {
                             DicItem *di = [self.typeDictList objectAtIndex:i];
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
    self.consignItem = [RERadioItem itemWithTitle:@"委托类型" value:@"" selectionHandler:^(RERadioItem *item)
                     {
                         [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                         NSMutableArray *options = [[NSMutableArray alloc] init];
                         for (NSInteger i = 0; i < self.consignDictList.count; i++)
                         {
                             DicItem *di = [self.consignDictList objectAtIndex:i];
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
    [section addItem:self.consignItem];
    self.payItem = [RERadioItem itemWithTitle:@"付佣类型" value:@"" selectionHandler:^(RERadioItem *item)
                        {
                            [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                            NSMutableArray *options = [[NSMutableArray alloc] init];
                            for (NSInteger i = 0; i < self.payDictList.count; i++)
                            {
                                DicItem *di = [self.payDictList objectAtIndex:i];
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
    [section addItem:self.payItem];
    self.startItem = [REDateTimeItem itemWithTitle:@"委托开始日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.startItem];
    self.endItem = [REDateTimeItem itemWithTitle:@"委托结束日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.endItem];

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
        [param setValue:self.sid forKey:@"contract_target_object"];
        if (!self.typeItem.value || self.typeItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择交易类型", @"O K", self);
            return;
        }
        for (DicItem *di in self.typeDictList)
        {
            if ([di.dict_label isEqualToString:self.typeItem.value])
            {
                [param setValue:di.dict_value forKey:@"trade_type"];
                break;
            }
        }
        if (!self.consignItem.value || self.consignItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择委托类型", @"O K", self);
            return;
        }
        for (DicItem *di in self.consignDictList)
        {
            if ([di.dict_label isEqualToString:self.consignItem.value])
            {
                [param setValue:di.dict_value forKey:@"contract_type"];
                break;
            }
        }
        if (!self.payItem.value || self.payItem.value.length <= 0)
        {
            PRESENTALERT(@"错 误", @"请选择付佣类型", @"O K", self);
            return;
        }
        for (DicItem *di in self.payDictList)
        {
            if ([di.dict_label isEqualToString:self.payItem.value])
            {
                [param setValue:di.dict_value forKey:@"contract_pay_sort"];
                break;
            }
        }
        if (!self.startItem.value)
        {
            PRESENTALERT(@"错 误", @"请选择委托开始日期", @"O K", self);
            return;
        }
        [param setValue:self.startItem.value forKey:@"contract_start_date"];
        if (!self.endItem.value)
        {
            PRESENTALERT(@"错 误", @"请选择委托结束日期", @"O K", self);
            return;
        }
        [param setValue:self.endItem.value forKey:@"contract_end_date"];
        SHOWHUD_WINDOW;
        [ContractDataPuller pushNewContractWithParam:param Success:^(NSString *att)
        {
            HIDEHUD_WINDOW;
            PRESENTALERT(@"提交成功", @"请立刻上传附件", @"O K", self);
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

@end
