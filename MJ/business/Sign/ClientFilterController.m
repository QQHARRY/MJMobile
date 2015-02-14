//
//  ClientFilterController.m
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "ClientFilterController.h"
#import "dictionaryManager.h"
#import "Macro.h"
#import "SignDataPuller.h"
#import "UtilFun.h"
#import "AppDelegate.h"
#import "person.h"
#import "ClientFilter.h"
#import "ClientTableViewController.h"

@interface ClientFilterController ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, readwrite, nonatomic) RETableViewSection *exactQuerySection;
@property (strong, readwrite, nonatomic) RERadioItem *salesNameItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *startTimeItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *endTimeItem;

@property (strong, readwrite, nonatomic) RETableViewSection *commitSection;

@property (nonatomic, strong) person *sales;

@end

@implementation ClientFilterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"客户筛选";
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];

    // add section
    self.exactQuerySection = [self addExactQueryControls];
    self.commitSection = [self addCommitButton];
}

- (RETableViewSection *)addExactQueryControls
{
    __typeof (&*self) __weak weakSelf = self;

    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"客户查询"];
    [self.manager addSection:section];
    
    self.salesNameItem = [RERadioItem itemWithTitle:@"员工姓名" value:@"" selectionHandler:^(RERadioItem *item)
                          {
                              [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
                              ContactListTableViewController *vc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] instantiateViewControllerWithIdentifier:@"ContactListTableViewController" AndClass:[ContactListTableViewController class]];
                              vc.selectMode = YES;
                              vc.singleSelect = YES;
                              vc.singleSelectCanSelectDepart = YES;
                              vc.selectResultDelegate = self;
                              [weakSelf.navigationController pushViewController:vc animated:YES];
                          }];
    [section addItem:self.salesNameItem];
    self.startTimeItem = [REDateTimeItem itemWithTitle:@"最早登记日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.startTimeItem];
    self.endTimeItem = [REDateTimeItem itemWithTitle:@"最晚登记日期" value:nil placeholder:nil format:@"yyyy-MM-dd hh:mm" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.endTimeItem];

    return section;
}

- (RETableViewSection *)addCommitButton
{
    RETableViewSection *section = [RETableViewSection section];
    [self.manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"查询" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item)
    {
        ClientFilter *filter = [[ClientFilter alloc] init];
        filter.FromID = @"0";
        filter.ToID = @"0";
        filter.Count = @"20";
        if (self.sales)
        {
            filter.client_owner_no = self.sales.job_no;
            filter.dept_current_no = self.sales.department_no;
        }
        if (self.startTimeItem.value)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            filter.start_date = [dateFormatter stringFromDate:self.startTimeItem.value];
        }
        if (self.endTimeItem.value)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            filter.end_date = [dateFormatter stringFromDate:self.endTimeItem.value];
        }

        ClientTableViewController *vc = [[ClientTableViewController alloc] initWithNibName:@"ClientTableViewController" bundle:[NSBundle mainBundle]];
        vc.filter = filter;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
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

-(void)returnClientSelection:(NSDictionary *)client
{
    if (self.delegate)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate returnClientSelection:client];
    }
}

@end


