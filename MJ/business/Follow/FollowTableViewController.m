//
//  FollowTableViewController.m
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "FollowTableViewController.h"
#import "MJRefresh.h"
#import "UtilFun.h"
#import "FollowDataPuller.h"
#import "FollowAddController.h"
//#import "HouseDetailCell.h"
//#import "HouseDetail.h"
//#import "UIImageView+AFNetworking.h"
//#import "Macro.h"
//#import "dictionaryManager.h"
//#import "HouseParticularTableViewController.h"

@interface FollowTableViewController ()

@property (nonatomic, strong) NSMutableArray *followList;
//@property (nonatomic, strong) NSArray *fitmentDictList;
//@property (nonatomic, strong) NSArray *leaseDictList;
//@property (nonatomic, strong) NSArray *saleDictList;

@end

@implementation FollowTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"跟进列表";
    
    // init data
    self.followList = [NSMutableArray array];
    
    // add title button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(onAddAction:)];

//
//    // get dict
//    self.fitmentDictList = [dictionaryManager getItemArrByType:DIC_FITMENT_TYPE];
//    self.leaseDictList = [dictionaryManager getItemArrByType:DIC_LEASE_TRADE_STATE];
//    self.saleDictList = [dictionaryManager getItemArrByType:DIC_SALE_TRADE_STATE];
//
    // header & footer refresh
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
//    [self.tableView addFooterWithTarget:self action:@selector(loadMore)];
}

- (void)onAddAction:(id)sender
{
    FollowAddController *vc = [[FollowAddController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    // clear
    [self.followList removeAllObjects];
    // get
    SHOWHUD_WINDOW;
    [FollowDataPuller pullDataWithFilter:nil Success:^(NSArray *houseDetailList)
    {
        HIDEHUD_WINDOW;
        [self.followList addObjectsFromArray:houseDetailList];
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
//    // reset
//    HouseDetail *hd = [self.houseList lastObject];
//    self.filter.ToID = @"0";
//    self.filter.FromID = hd.house_trade_no;
//    // get
//    SHOWHUD_WINDOW;
//    [HouseDataPuller pullDataWithFilter:self.filter Success:^(NSArray *houseDetailList)
//     {
//         HIDEHUD_WINDOW;
//         [self.houseList addObjectsFromArray:houseDetailList];
//         [self.tableView reloadData];
//         [self.tableView footerEndRefreshing];
//     }
//                                failure:^(NSError *e)
//     {
//         HIDEHUD_WINDOW;
//         [self.tableView footerEndRefreshing];
//     }];
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
    return self.followList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
/*    static NSString *CellIdentifier = @"HouseDetailCell";
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
  
    HouseDetail *hd = [self.houseList objectAtIndex:indexPath.row];
    NSString *thunmbnailStr = [SERVER_ADD stringByAppendingString:hd.ThumbnailUrl];
//    NSLog(@"%@", thunmbnailStr);
    [cell.thunmbnail setImageWithURL:[NSURL URLWithString:thunmbnailStr] placeholderImage:[UIImage imageNamed:@"LoadPlaceHolder"]];
    cell.title.text = hd.buildings_name;
    cell.house.text = [NSString stringWithFormat:@"%@室%@厅%@厨%@卫 %@m²", hd.room_num, hd.hall_num, hd.kitchen_num, hd.toilet_num, hd.build_structure_area];
    cell.price.text = (self.controllerType == HCT_RENT) ? ([NSString stringWithFormat:@"%@元/月", hd.lease_value_total]) : ([NSString stringWithFormat:@"%@元", hd.sale_value_total]);
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

    return cell;*/
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HouseDetail *hd = [self.houseList objectAtIndex:indexPath.row];
//    HouseParticularTableViewController*ptcl = [[HouseParticularTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    ptcl.houseDtl = hd;
//    [self pushControllerToController:ptcl];
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
