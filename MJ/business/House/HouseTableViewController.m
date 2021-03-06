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
@property (nonatomic, strong) NSArray *lookPermitDictList;
@property (nonatomic, strong) NSArray *consignmentTypeDictList;

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
    self.lookPermitDictList = [dictionaryManager getItemArrByType:DIC_LOOK_PERMIT_TYPE];
    self.consignmentTypeDictList = [dictionaryManager getItemArrByType:DIC_CONSIGNMENT_TYPE];
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
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMore
{
    // reset
    HouseDetail *hd = [self.houseList lastObject];
    self.filter.ToID = @"0";
    self.filter.FromID = hd.trade_no;
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
    return 100;
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
    if(hd.album_thumb_path){
        NSString *thunmbnailStr = hd.album_thumb_path;
        [cell.thunmbnail setImageWithURL:[NSURL URLWithString:thunmbnailStr] placeholderImage:[UIImage imageNamed:@"banner_no.jpg"]];
    }else
    {
        [cell.thunmbnail setImage:[UIImage imageNamed:@"banner_no.jpg"]];
    }
    
    cell.title.text = hd.domain_name;
    cell.house.text = [NSString stringWithFormat:@"%@室%@厅%@卫", hd.room_num, hd.hall_num,hd.toilet_num];
    
    cell.area.text = [NSString stringWithFormat:@"%@m²",hd.structure_area];
    cell.price.text = (self.controllerType == HCT_RENT) ? ([NSString stringWithFormat:@"%@元/月", hd.rent_listing]) : ([NSString stringWithFormat:@"%.1f万", [hd.sale_listing floatValue] / 10000.0f]);
    cell.floor.text = [NSString stringWithFormat:@"%@/%@楼", hd.house_floor, hd.floor_count];
    
    
    {
        cell.fitment.hidden = [hd.fitment_type stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
        for (DicItem *di in self.fitmentDictList)
        {
            if ([di.dict_value isEqualToString:hd.fitment_type])
            {
                cell.fitment.text = di.dict_label;
                break;
            }
        }
    }
    
    
    {
        cell.lookPermit.hidden = [hd.look_permit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;

            for (DicItem *di in self.lookPermitDictList)
            {
                if ([di.dict_value isEqualToString:hd.look_permit])
                {
                    cell.lookPermit.text = di.dict_label;
                    
                    break;
                }
            }
    
    }
    {
        cell.consignmentType.hidden = [hd.consignment_type stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
        for (DicItem *di in self.consignmentTypeDictList)
        {
            if ([di.dict_value isEqualToString:hd.consignment_type])
            {
                cell.consignmentType.text = di.dict_label;
                cell.consignmentType.hidden = [hd.look_permit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
                break;
            }
        }
    }
    
    
    
    if (self.controllerType == HCT_RENT)
    {
        cell.status.hidden = [hd.lease_state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
        for (DicItem *di in self.leaseDictList)
        {
            if ([di.dict_value isEqualToString:hd.lease_state])
            {
                cell.status.text = di.dict_label;
                break;
            }
        }
    }
    else
    {
        cell.status.hidden = [hd.sale_state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
        for (DicItem *di in self.saleDictList)
        {
            if ([di.dict_value isEqualToString:hd.sale_state])
            {
                cell.status.text = di.dict_label;
                break;
            }
        }
    }

    
    
    
    [self setPublicStauts:hd ForCell:cell];
    
    return cell;
}


-(void)setPublicStauts:(HouseDetail*)houseDetails ForCell:(HouseDetailCell*)cell
{
    if (houseDetails && cell)
    {
        [cell setPublicStatus:[houseDetails getRegTypeInt] AndLeftDays:houseDetails.reg_surplus];
    }
    
    
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
