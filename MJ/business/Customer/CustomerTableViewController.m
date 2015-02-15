//
//  CustomerTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "CustomerTableViewController.h"
#import "CustomerDataPuller.h"
#import "UtilFun.h"
#import "CustomerDetailCell.h"
#import "CustomerDetail.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "Macro.h"
#import "dictionaryManager.h"
#import "CustomerParticularTableViewController.h"

@interface CustomerTableViewController ()

@property (nonatomic, strong) NSMutableArray *CustomerList;

@end

@implementation CustomerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init data
    self.CustomerList = [NSMutableArray array];
    
    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    
    [self refreshData];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//}

- (void)refreshData
{
    // clear
    [self.CustomerList removeAllObjects];
    // reset
    self.filter.FromID = @"0";
    self.filter.ToID = @"0";
    // get
    SHOWHUD_WINDOW;
    [CustomerDataPuller pullDataWithFilter:self.filter Success:^(NSArray *CustomerDetailList)
    {
        HIDEHUD_WINDOW;
        [self.CustomerList addObjectsFromArray:CustomerDetailList];
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
    CustomerDetail *hd = [self.CustomerList lastObject];
    self.filter.ToID = @"0";
    self.filter.FromID = hd.business_requirement_no;
    // get
    SHOWHUD_WINDOW;
    [CustomerDataPuller pullDataWithFilter:self.filter Success:^(NSArray *CustomerDetailList)
     {
         HIDEHUD_WINDOW;
         [self.CustomerList addObjectsFromArray:CustomerDetailList];
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
    return self.CustomerList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerDetailCell";
    CustomerDetailCell *cell = (CustomerDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CustomerDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[CustomerDetailCell class]])
            {
                cell = (CustomerDetailCell *)oneObject;
            }
        }
    }
  
    if (indexPath.row >= [self.CustomerList count])
    {
        return cell;
    }
    CustomerDetail *cd = [self.CustomerList objectAtIndex:indexPath.row];
    cell.title.text = cd.house_urban;
    cell.customer.text = cd.client_name;
    if (self.controllerType == CCT_RENT)
    {
        cell.price.text = [NSString stringWithFormat:@"%@-%@%@", cd.requirement_lease_price_from, cd.requirement_lease_price_to, cd.lease_price_unit];
    }
    else
    {
        cell.price.text = [NSString stringWithFormat:@"%@-%@%@", cd.requirement_sale_price_from, cd.requirement_sale_price_to, cd.sale_price_unit];
    }
    cell.house.text = [NSString stringWithFormat:@"%@-%@层 %@-%@室 %@-%@厅 %@-%@m²", cd.requirement_floor_from, cd.requirement_floor_to, cd.requirement_room_from, cd.requirement_room_to, cd.requirement_hall_from, cd.requirement_hall_to, cd.requirement_area_from, cd.requirement_area_to];
    cell.time.text = [NSString stringWithFormat:@"%@登记", cd.buildings_create_time];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerDetail *cd = [self.CustomerList objectAtIndex:indexPath.row];
    CustomerParticularTableViewController*ptcl = [[CustomerParticularTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ptcl.detail = cd;
    [self pushControllerToController:ptcl];
}

-(void)pushControllerToController:(UIViewController*)vc
{
    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)])
    {
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([((UIViewController*)(self.container)).navigationController respondsToSelector:@selector(pushViewController:animated:)])
    {
        [((UIViewController*)(self.container)).navigationController pushViewController:vc animated:YES];
    }
}



@end
