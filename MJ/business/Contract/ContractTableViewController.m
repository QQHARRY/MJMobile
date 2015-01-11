//
//  ContractTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "ContractTableViewController.h"
#import "MJRefresh.h"
#import "UtilFun.h"
#import "ContractDataPuller.h"
#import "ContractAddController.h"
#import "ContractDetailCell.h"

@interface ContractTableViewController ()

@property (nonatomic, strong) NSMutableArray *ContractList;

@end

@implementation ContractTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"委托列表";
    
    // init data
    self.ContractList = [NSMutableArray array];
    
    // add title button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddAction:)];

    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
}

- (void)onAddAction:(id)sender
{
    ContractAddController *vc = [[ContractAddController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.sid = self.sid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.ContractList removeAllObjects];
    // get
    SHOWHUD_WINDOW;
    [ContractDataPuller pullDataWithFilter:self.sid Success:^(NSArray *ContractList)
    {
        HIDEHUD_WINDOW;
        [self.ContractList addObjectsFromArray:ContractList];
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
    return self.ContractList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContractDetailCell";
    ContractDetailCell *cell = (ContractDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ContractDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[ContractDetailCell class]])
            {
                cell = (ContractDetailCell *)oneObject;
            }
        }
    }
  
    NSDictionary *d = [self.ContractList objectAtIndex:indexPath.row];
    cell.type.text = [d objectForKey:@"contract_type"];
    cell.state.text = [d objectForKey:@"contract_status"];
    cell.dept.text = [d objectForKey:@"department_name"];
    cell.man.text = [d objectForKey:@"name_full"];
    cell.limit.text = [d objectForKey:@"contract_end_date"];
    cell.time.text = [d objectForKey:@"contract_start_date"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
