//
//  HouseSelectBuildingTableViewController.m
//  MJ
//
//  Created by harry on 15/1/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseSelectBuildingTableViewController.h"
#import "buildingItemTableViewCell.h"
#import "UtilFun.h"
#import "HouseDataPuller.h"


@interface HouseSelectBuildingTableViewController ()

@end

@implementation HouseSelectBuildingTableViewController


+(id)initWithDelegate:(id)dele BuildingsArr:(NSArray*)bldings AndCompleteHandler:(void (^)(building*bld))hdl
{
    HouseSelectBuildingTableViewController*ctrl = [[HouseSelectBuildingTableViewController alloc] initWithStyle:UITableViewStylePlain];
    if (ctrl)
    {
        ctrl.buildingsArr = [[NSMutableArray alloc] init];
        [ctrl.buildingsArr addObjectsFromArray:bldings];
        ctrl.handler = hdl;
    }
    return ctrl;
    
}

+(id)initWithDelegate:(id)dele Buildings:(buildings*)bldings AndCompleteHandler:(void (^)(building*bld))hdl
{
    HouseSelectBuildingTableViewController*ctrl = [[HouseSelectBuildingTableViewController alloc] initWithStyle:UITableViewStylePlain];
    if (ctrl)
    {
        ctrl.buildingsArr = [[NSMutableArray alloc] init];
        ctrl.blds = bldings;
        ctrl.handler = hdl;
    }
    return ctrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"栋座";
    
    if ([self.buildingsArr count] == 0 && self.blds)
    {
        [self refreshData];
    }
    
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
    return [self.buildingsArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"buildingItemTableViewCell";
    buildingItemTableViewCell *cell = (buildingItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[buildingItemTableViewCell class]])
            {
                cell = (buildingItemTableViewCell *)oneObject;
            }
        }
    }
    // Configure the cell...
    building*bld = [self.buildingsArr objectAtIndex:indexPath.row];
    
    if (bld && cell)
    {
        cell.build_full_name.text = bld.build_full_name;
        cell.unit_serial.text = bld.unit_serial;
        cell.floor_count.text = bld.floor_count;
        cell.elevator_house.text = bld.elevator_house;
    }
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    building*bld = [self.buildingsArr objectAtIndex:indexPath.row];
    if (bld  && self.handler)
    {
        self.handler(bld);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshData
{
    SHOWHUD_WINDOW;
    
    [HouseDataPuller pullBuildingDetailsByBuildingNO:self.blds.buildings_dict_no Success:^(buildingDetails *dtl,NSArray*arr)
     {
         [self.buildingsArr removeAllObjects];
         if (self.buildingsArr && [arr count] > 0)
         {
             [self.buildingsArr addObjectsFromArray:arr];
         }
         [self.tableView reloadData];
         HIDEHUD_WINDOW;
     }
                                            failure:^(NSError* error)
     {
         
         HIDEHUD_WINDOW;
     }];
}

@end
