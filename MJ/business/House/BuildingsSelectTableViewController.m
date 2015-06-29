//
//  BuildingsSelectTableViewController.m
//  MJ
//
//  Created by harry on 15/1/17.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "BuildingsSelectTableViewController.h"
#import "buildingsFilterViewController.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"
#import "BuildingsTableCell.h"
#import "MJRefresh.h"

@interface BuildingsSelectTableViewController ()

@property(nonatomic,strong)buildingsFilterViewController*filterCtrl;
@property(nonatomic,strong)NSMutableArray*buildingArr;

@end

@implementation BuildingsSelectTableViewController


+(id)initWithDelegate:(id)dele AndCompleteHandler:(void (^)(buildings*bld))hdl
{
    BuildingsSelectTableViewController*ctrl = [[BuildingsSelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    if (ctrl)
    {
        ctrl.weakDelegate = dele;
        ctrl.handler = hdl;
    }
    return ctrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buildingArr = [[NSMutableArray alloc] init];
    self.needRefresh = NO;
    self.filterCtrl = [[buildingsFilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.filterCtrl.buildingsSel = self;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(openFilter:)];
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    
    
    [self refreshData];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.needRefresh)
    {
        self.needRefresh = NO;
        [self refreshData];
    }
}

-(void)openFilter:(id)sender
{
    [self.navigationController pushViewController:self.filterCtrl animated:YES];
}

-(void)refreshData
{
    SHOWHUD_WINDOW;
    
    NSDictionary*filterDic = nil;
    if (self.filterCtrl)
    {
        filterDic = self.filterCtrl.queryCondition;
    }
    if (filterDic ==nil)
    {
        filterDic = [[NSMutableDictionary alloc] init];
    }
    [filterDic setValue:@"0" forKey:@"FromID"];
    [filterDic setValue:@"" forKey:@"ToID"];
    [filterDic setValue:@"8" forKey:@"Count"];
    [HouseDataPuller pullBuildingByContidion:filterDic  Success:^(NSArray*buildingsArr)
     {
         [self.tableView headerEndRefreshing];
         [self.buildingArr removeAllObjects];
         if (buildingsArr && [buildingsArr count] > 0)
         {
             [self.buildingArr addObjectsFromArray:buildingsArr];
         }
         [self.tableView reloadData];
         HIDEHUD_WINDOW;
     }failure:^(NSError* error)
     {
         [self.tableView headerEndRefreshing];
         HIDEHUD_WINDOW;
     }];
}


- (void)loadMore
{
    SHOWHUD_WINDOW;
    
    NSMutableDictionary*filterDic = nil;
    if (self.filterCtrl)
    {
        filterDic = self.filterCtrl.queryCondition;
    }
    
    if (filterDic ==nil)
    {
        filterDic = [[NSMutableDictionary alloc] init];
    }
    
    NSString*FromID = @"0";
    if (self.buildingArr.count > 0)
    {
        FromID = ((buildings*)[self.buildingArr objectAtIndex:[self.buildingArr count]-1]).domain_no;
    }
    [filterDic setValue:FromID forKey:@"FromID"];
    [filterDic setValue:@"" forKey:@"ToID"];
    [filterDic setValue:@"8" forKey:@"Count"];
    
    [HouseDataPuller pullBuildingByContidion:filterDic  Success:^(NSArray*buildingsArr)
     {
         [self.tableView footerEndRefreshing];
         if (buildingsArr && [buildingsArr count] > 0)
         {
             [self.buildingArr addObjectsFromArray:buildingsArr];
         }
         [self.tableView reloadData];
         HIDEHUD_WINDOW;
     }failure:^(NSError* error)
     {
         [self.tableView footerEndRefreshing];
         HIDEHUD_WINDOW;
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.buildingArr)
    {
        return self.buildingArr.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuildingsTableCell";
    BuildingsTableCell *cell = (BuildingsTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[BuildingsTableCell class]])
            {
                cell = (BuildingsTableCell *)oneObject;
            }
        }
    }
    // Configure the cell...
    buildings*bld = [self.buildingArr objectAtIndex:indexPath.row];
    
    if (bld && cell)
    {
        cell.buildings_name.text = bld.domain_name;
        cell.urbanname.text = bld.urbanname;
        cell.areaname.text = bld.areaname;
        cell.Buildings_address.text = bld.domain_address;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    buildings*bld = [self.buildingArr objectAtIndex:indexPath.row];
    if (bld  && self.handler)
    {
        self.handler(bld);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
