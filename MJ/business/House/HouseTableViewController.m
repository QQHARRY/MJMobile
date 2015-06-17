//
//  HouseTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseTableViewController.h"
#import "HouseDataPuller.h"
#import "UtilFun.h"
#import "HouseDetailCell.h"
#import "HouseDetail.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "Macro.h"
#import "dictionaryManager.h"
#import "HouseParticularTableViewController.h"
#import "NewHousePtlViewController.h"

@interface HouseTableViewController ()

@property (nonatomic, strong) NSMutableArray *houseList;
@property (nonatomic, strong) NSArray *fitmentDictList;
@property (nonatomic, strong) NSArray *leaseDictList;
@property (nonatomic, strong) NSArray *saleDictList;

@end

@implementation HouseTableViewController
@synthesize needRefreshData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init data
    self.houseList = [NSMutableArray array];
    
    // get dict
    self.fitmentDictList = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
    self.leaseDictList = [dictionaryManager getItemArrByType:DIC_LEASE_TRADE_STATE];
    self.saleDictList = [dictionaryManager getItemArrByType:DIC_SALE_TRADE_STATE];

    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
    needRefreshData = NO;
    
    [self refreshData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (needRefreshData)
    {
        needRefreshData = NO;
        [self refreshData];
    }
    
}

- (void)refreshData
{
    // clear
    [self.houseList removeAllObjects];
    // reset
    self.filter.FromID = @"0";
    self.filter.ToID = @"0";
    // get
    SHOWHUD(self.view);
    [HouseDataPuller pullDataWithFilter:self.filter Success:^(NSArray *houseDetailList)
    {
        HIDEHUD(self.view);
        [self.houseList addObjectsFromArray:houseDetailList];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }
                                failure:^(NSError *e)
    {
        HIDEHUD(self.view);
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMore
{
    // reset
    HouseDetail *hd = [self.houseList lastObject];
    self.filter.ToID = @"0";
    self.filter.FromID = hd.house_trade_no;
    // get
    SHOWHUD(self.view);
    [HouseDataPuller pullDataWithFilter:self.filter Success:^(NSArray *houseDetailList)
     {
         HIDEHUD(self.view);
         [self.houseList addObjectsFromArray:houseDetailList];
         [self.tableView reloadData];
         [self.tableView footerEndRefreshing];
     }
                                failure:^(NSError *e)
     {
         HIDEHUD(self.view);
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
    return self.houseList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HouseDetailCell";
    HouseDetailCell *cell = (HouseDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HouseDetailCell" owner:self options:nil];
        for(id oneObject in nibs)
        {
            if([oneObject isKindOfClass:[HouseDetailCell class]])
            {
                cell = (HouseDetailCell *)oneObject;
            }
        }
    }
    if (self.houseList.count <= 0)
    {
        return cell;
    }

    HouseDetail *hd = [self.houseList objectAtIndex:indexPath.row];
    NSString *thunmbnailStr = [SERVER_ADD stringByAppendingString:hd.ThumbnailUrl];
//    NSLog(@"%@", thunmbnailStr);
    [cell.thunmbnail setImageWithURL:[NSURL URLWithString:thunmbnailStr] placeholderImage:[UIImage imageNamed:@"LoadPlaceHolder"]];
    cell.title.text = hd.buildings_name;
    cell.house.text = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫 %@m²", hd.room_num, hd.hall_num, hd.kitchen_num, hd.toilet_num, hd.build_structure_area];
    cell.price.text = (self.controllerType == HCT_RENT) ? ([NSString stringWithFormat:@"%@元/月", hd.lease_value_total]) : ([NSString stringWithFormat:@"%.1f万元", [hd.sale_value_total floatValue] / 10000.0]);
    cell.floor.text = [NSString stringWithFormat:@"%@/%@楼", hd.house_floor, hd.floor_count];
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
    if (self.controllerType == HCT_RENT)
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
    if (indexPath.row >= self.houseList.count)
    {
        return;
    }
    HouseDetail *hd = [self.houseList objectAtIndex:indexPath.row];
    
    BOOL b = YES;
    
    if (b)
    {
        HouseParticularTableViewController*ptcl = [[HouseParticularTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ptcl.hidesBottomBarWhenPushed = YES;
        ptcl.houseDtl = hd;
        ptcl.mode = PAICULARMODE_READ;
        [self pushControllerToController:ptcl];
        b = !b;
    }
//    else
//    {
//        NewHousePtlViewController*ptcl = [[NewHousePtlViewController alloc] init];
//        ptcl.houseDtl = hd;
//        ptcl.hidesBottomBarWhenPushed = YES;
//        [self pushControllerToController:ptcl];
//        b = !b;
//    }

    
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
