//
//  ClientTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ClientTableViewController.h"
#import "SignDataPuller.h"
#import "UtilFun.h"
#import "ClientDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "Macro.h"
#import "dictionaryManager.h"

@interface ClientTableViewController ()

@property (nonatomic, strong) NSMutableArray *ClientList;

@end

@implementation ClientTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // title
    self.title = @"客户列表";
    
    // init data
    self.ClientList = [NSMutableArray array];
    
    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.ClientList removeAllObjects];
    // reset
    self.filter.FromID = @"0";
    self.filter.ToID = @"0";
    // get
    SHOWHUD_WINDOW;
    [SignDataPuller pullClientWithFilter:self.filter Success:^(NSArray *clientList)
    {
        HIDEHUD_WINDOW;
        [self.ClientList addObjectsFromArray:clientList];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }
                                failure:^(NSError *e)
    {
        HIDEHUD_WINDOW;
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMore
{
    // reset
    NSDictionary *d = [self.ClientList lastObject];
    self.filter.ToID = @"0";
    self.filter.FromID = [d objectForKey:@"client_base_no"];
    // get
    SHOWHUD_WINDOW;
    [SignDataPuller pullClientWithFilter:self.filter Success:^(NSArray *clientList)
     {
         HIDEHUD_WINDOW;
         [self.ClientList addObjectsFromArray:clientList];
         [self.tableView reloadData];
         [self.tableView footerEndRefreshing];
     }
                                failure:^(NSError *e)
     {
         HIDEHUD_WINDOW;
         [self.tableView footerEndRefreshing];
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
    return self.ClientList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientDetailCell";
    ClientDetailCell *cell = (ClientDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ClientDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ClientDetailCell class]])
            {
                cell = (ClientDetailCell *)oneObject;
            }
        }
    }
  
    if (indexPath.row >= [self.ClientList count])
    {
        return cell;
    }
    NSDictionary *d = [self.ClientList objectAtIndex:indexPath.row];
    cell.name.text = [d objectForKey:@"client_name"];
    cell.require.text = [d objectForKey:@"house_area"];
    cell.sales.text = [d objectForKey:@"name_full"];
    cell.depart.text = [d objectForKey:@"dept_name"];
    cell.time.text = [NSString stringWithFormat:@"%@登记", [d objectForKey:@"buildings_create_time"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d = [self.ClientList objectAtIndex:indexPath.row];
    if (self.delegate)
    {
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate returnClientSelection:d];
    }
}



@end
