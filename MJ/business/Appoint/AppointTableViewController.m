//
//  AppointTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AppointTableViewController.h"
#import "MJRefresh.h"
#import "UtilFun.h"
#import "AppointDataPuller.h"
#import "AppointDetailCell.h"

@interface AppointTableViewController ()

@property (nonatomic, strong) NSMutableArray *AppointList;

@end

@implementation AppointTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"跟进列表";
    
    // init data
    self.AppointList = [NSMutableArray array];
    
    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.AppointList removeAllObjects];
    // get
    SHOWHUD_WINDOW;
    [AppointDataPuller pullDataWithFilter:self.sid Success:^(NSArray *AppointList)
    {
        HIDEHUD_WINDOW;
        [self.AppointList addObjectsFromArray:AppointList];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }
                                failure:^(NSError *e)
    {
        HIDEHUD_WINDOW;
        [self.tableView headerEndRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.AppointList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AppointDetailCell";
    AppointDetailCell *cell = (AppointDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AppointDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[AppointDetailCell class]])
            {
                cell = (AppointDetailCell *)oneObject;
            }
        }
    }
  
    NSDictionary *d = [self.AppointList objectAtIndex:indexPath.row];
    cell.type.text = [d objectForKey:@"task_type_label"];
    cell.remind.text = [[d objectForKey:@"task_reminder_flg"] isEqualToString:@"1"] ? @"是" : @"否";
    cell.man.text = [d objectForKey:@"name_full"];
    cell.time.text = [d objectForKey:@"task_Appoint_time"];
    cell.content.text = [d objectForKey:@"task_Appoint_content"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
