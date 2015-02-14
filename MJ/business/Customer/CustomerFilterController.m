//
//  CustomerFilterController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "CustomerFilterController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "CustomerDataPuller.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "AppDelegate.h"
#import "person.h"

@interface CustomerFilterController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *exactQuerySection;
@property (strong, readwrite, nonatomic) RERadioItem *belongAreaItem;
@property (strong, readwrite, nonatomic) RERadioItem *belongSectionItem;
@property (strong, readwrite, nonatomic) RERadioItem *salesNameItem;
@property (strong, readwrite, nonatomic) RETextItem *customerNameItem;
@property (strong, readwrite, nonatomic) RETextItem *customerPhoneItem;
@property (strong, readwrite, nonatomic) RERadioItem *statusItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *startTimeItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *endTimeItem;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) person *sales;
@property (nonatomic, strong) NSArray *requirementDictList;
@property (nonatomic, strong) NSArray *areaDictList;

@end

@implementation CustomerFilterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"客源筛选";
    
    // get dict
    self.requirementDictList = [dictionaryManager getItemArrByType:DIC_REQUIREMENT_STATE];
    self.areaDictList = [NSArray array];
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.exactQuerySection = [self addExactQueryControls];
    self.commitSection = [self addCommitButton];
}

- (RETableViewSection *)addExactQueryControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"精确查询"];
    [self.manager addSection:section];
    self.belongAreaItem = [RERadioItem itemWithTitle:@"需求城区" value:@"" selectionHandler:^(RERadioItem *item)
                           {
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
                                                                                               [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                               self.belongSectionItem.value = @"";
                                                                                               [self.tableView reloadData];
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
                                                                                          [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                                          self.belongSectionItem.value = @"";
                                                                                          [self.tableView reloadData];
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
                               }
                           }];
    [section addItem:self.belongAreaItem];
    self.belongSectionItem = [RERadioItem itemWithTitle:@"需求片区" value:@"" selectionHandler:^(RERadioItem *item)
                              {
                                  [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                  NSMutableArray *options = [[NSMutableArray alloc] init];
                                  NSDictionary *dstDict = nil;
                                  for (NSDictionary *areaDict in self.areaDictList)
                                  {
                                      if ([[[areaDict objectForKey:@"dict"] objectForKey:@"areas_name"] isEqualToString:self.belongAreaItem.value])
                                      {
                                          dstDict = areaDict;
                                          break;
                                      }
                                  }
                                  if (dstDict && dstDict.count > 0)
                                  {
                                      NSArray*sectionArr = [dstDict objectForKey:@"sections"];
                                      for (NSInteger i = 0; i < sectionArr.count; i++)
                                      {
                                          [options addObject:[[sectionArr objectAtIndex:i] objectForKey:@"areas_name"]];
                                      }
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
    [section addItem:self.belongSectionItem];
    self.startTimeItem = [REDateTimeItem itemWithTitle:@"最早登记日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.startTimeItem];
    self.endTimeItem = [REDateTimeItem itemWithTitle:@"最晚登记日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.endTimeItem];
    self.salesNameItem = [RERadioItem itemWithTitle:@"员工姓名" value:@"" selectionHandler:^(RERadioItem *item)
                              {
                                  [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                                  ContactListTableViewController *vc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] instantiateViewControllerWithIdentifier:@"ContactListTableViewController" AndClass:[ContactListTableViewController class]];
                                  vc.selectMode = YES;
                                  vc.singleSelect = YES;
                                  vc.selectResultDelegate = self;
                                  [weakSelf.navigationController pushViewController:vc animated:YES];
                              }];
    [section addItem:self.salesNameItem];
    self.customerNameItem = [RETextItem itemWithTitle:@"客户姓名" value:nil placeholder:@""];
    [section addItem:self.customerNameItem];
    self.customerPhoneItem = [RETextItem itemWithTitle:@"客户电话" value:nil placeholder:@""];
    self.customerPhoneItem.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.customerPhoneItem];
    self.statusItem = [RERadioItem itemWithTitle:@"客源状态" value:@"" selectionHandler:^(RERadioItem *item)
                            {
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
    [section addItem:self.statusItem];
    return section;
}

- (RETableViewSection *)addCommitButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
    {
        CustomerFilter *filter = (self.hvc.nowControllerType == CCT_SELL) ? self.hvc.sellController.filter : self.hvc.rentController.filter;
        filter.FromID = @"0";
        filter.ToID = @"0";
        filter.house_urban = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            if ([[[areaDict objectForKey:@"dict"] objectForKey:@"areas_name"] isEqualToString:self.belongAreaItem.value])
            {
                filter.house_urban = [areaDict objectForKey:@"no"];
                break;
            }
        }
        filter.house_area = @"";
        for (NSDictionary *areaDict in self.areaDictList)
        {
            NSArray *sectionList = [areaDict objectForKey:@"sections"];
            BOOL bFind = false;
            for (NSDictionary *sectionDict in sectionList)
            {
                if ([[sectionDict objectForKey:@"areas_name"] isEqualToString:self.belongSectionItem.value])
                {
                    filter.house_area = [sectionDict objectForKey:@"areas_current_no"];
                    bFind = true;
                    break;
                }
            }
            if (bFind)
            {
                break;
            }
        }
        filter.requirement_status = @"";
        for (DicItem *di in self.requirementDictList)
        {
            if ([di.dict_label isEqualToString:self.statusItem.value])
            {
                filter.requirement_status = di.dict_value;
                break;
            }
        }
        filter.client_name = self.customerNameItem.value;
        filter.obj_mobile = self.customerPhoneItem.value;
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            filter.start_date = [dateFormatter stringFromDate:self.startTimeItem.value];
        }
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            filter.end_date = [dateFormatter stringFromDate:self.endTimeItem.value];
        }
        if (self.sales)
        {
            filter.user_no = self.sales.job_no;
        }
        else
        {
            filter.user_no = @"";
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    return section;
}

-(void)returnSelection:(NSArray*)curSelection
{
    person *p = [curSelection lastObject];
    if (!p || ![p isKindOfClass:[person class]])
    {
        self.sales = nil;
        return;
    }
    self.salesNameItem.value = p.name_full;
    self.sales = p;
    [self.tableView reloadData];
}

@end
