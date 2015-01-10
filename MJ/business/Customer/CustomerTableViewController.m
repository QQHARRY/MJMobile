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

@interface CustomerTableViewController ()

@property (nonatomic, strong) NSMutableArray *CustomerList;
@property (nonatomic, strong) NSArray *fitmentDictList;
@property (nonatomic, strong) NSArray *leaseDictList;
@property (nonatomic, strong) NSArray *saleDictList;

@end

@implementation CustomerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init data
    self.CustomerList = [NSMutableArray array];
    
    // get dict
    self.fitmentDictList = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.leaseDictList = [dictionaryManager getItemArrByType:DIC_LEASE_TRADE_STATE];
    self.saleDictList = [dictionaryManager getItemArrByType:DIC_SALE_TRADE_STATE];

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
    self.filter.FromID = hd.Customer_trade_no;
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
  
    CustomerDetail *hd = [self.CustomerList objectAtIndex:indexPath.row];
    NSString *thunmbnailStr = [SERVER_ADD stringByAppendingString:hd.ThumbnailUrl];
//    NSLog(@"%@", thunmbnailStr);
    [cell.thunmbnail setImageWithURL:[NSURL URLWithString:thunmbnailStr] placeholderImage:[UIImage imageNamed:@"LoadPlaceHolder"]];
    cell.title.text = hd.buildings_name;
    cell.Customer.text = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫 %@m²", hd.room_num, hd.hall_num, hd.kitchen_num, hd.toilet_num, hd.build_structure_area];
    cell.price.text = (self.controllerType == CCT_RENT) ? ([NSString stringWithFormat:@"%@元/月", hd.lease_value_total]) : ([NSString stringWithFormat:@"%@元", hd.sale_value_total]);
    cell.floor.text = [NSString stringWithFormat:@"%@/%@楼", hd.Customer_floor, hd.floor_count];
    {
        for (DicItem *di in self.fitmentDictList)
        {
            if ([di.dict_value isEqualToString:hd.fitment_type])
            {
                cell.fitment.text = di.dict_label;
                break;
            }
        }
    }
    if (self.controllerType == CCT_RENT)
    {
        for (DicItem *di in self.leaseDictList)
        {
            if ([di.dict_value isEqualToString:hd.lease_trade_state])
            {
                cell.status.text = di.dict_label;
                break;
            }
        }
    }
    else
    {
        for (DicItem *di in self.saleDictList)
        {
            if ([di.dict_value isEqualToString:hd.sale_trade_state])
            {
                cell.status.text = di.dict_label;
                break;
            }
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    messageObj*obj = [msgArr objectAtIndex:indexPath.row];
//    MessageDetailsViewController*detailsView = [[MessageDetailsViewController alloc ] initWithNibName:@"MessageDetailsViewController" bundle:[NSBundle mainBundle]];
//    
//    detailsView.msg = obj;
//    [self pushControllerToController:detailsView];
}

-(void)pushControllerToController:(UIViewController*)vc
{
//    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)])
//    {
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
//    
//    if ([((UIViewController*)(self.container)).navigationController respondsToSelector:@selector(pushViewController:animated:)])
//    {
//        [((UIViewController*)(self.container)).navigationController pushViewController:vc animated:YES];
//    }
}



@end
