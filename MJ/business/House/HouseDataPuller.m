//
//  HouseDataPuller.m
//  MJ
//
//  Created by harry on 14/12/12.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseDataPuller.h"
#import "Macro.h"
#import "person.h"
#import "NetWorkManager.h"
#import "HouseDetail.h"
#import "bizManager.h"

@implementation HouseDataPuller

+(void)pullDataWithFilter:(HouseFilter *)filter Success:(void (^)(NSArray *houseDetailList))success failure:(void (^)(NSError *error))failure;
{
    assert(filter);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[person me].job_no forKey:@"job_no"];
    [param setValue:[person me].password forKey:@"acc_password"];
    if (filter.consignment_type && filter.consignment_type.length > 0)
    {
        [param setValue:filter.consignment_type forKey:@"consignment_type"];
    }
    if (filter.trade_type && filter.trade_type.length > 0)
    {
        [param setValue:filter.trade_type forKey:@"trade_type"];
    }
    if (filter.sale_trade_state && filter.sale_trade_state.length > 0)
    {
        [param setValue:filter.sale_trade_state forKey:@"sale_trade_state"];
    }
    if (filter.lease_trade_state && filter.lease_trade_state.length > 0)
    {
        [param setValue:filter.lease_trade_state forKey:@"lease_trade_state"];
    }
    if (filter.hall_num && filter.hall_num.length > 0)
    {
        [param setValue:filter.hall_num forKey:@"hall_num"];
    }
    if (filter.room_num && filter.room_num.length > 0)
    {
        [param setValue:filter.room_num forKey:@"room_num"];
    }
    if (filter.buildname && filter.buildname.length > 0)
    {
        [param setValue:filter.buildname forKey:@"buildname"];
    }
    if (filter.house_unit && filter.house_unit.length > 0)
    {
        [param setValue:filter.house_unit forKey:@"house_unit"];
    }
    if (filter.house_fluor && filter.house_fluor.length > 0)
    {
        [param setValue:filter.house_fluor forKey:@"house_fluor"];
    }
    if (filter.house_tablet && filter.house_tablet.length > 0)
    {
        [param setValue:filter.house_tablet forKey:@"house_tablet"];
    }
    if (filter.house_driect && filter.house_driect.length > 0)
    {
        [param setValue:filter.house_driect forKey:@"house_driect"];
    }
    if (filter.structure_area_from && filter.structure_area_from.length > 0)
    {
        [param setValue:filter.structure_area_from forKey:@"structure_area_from"];
    }
    if (filter.structure_area_to && filter.structure_area_to.length > 0)
    {
        [param setValue:filter.structure_area_to forKey:@"structure_area_to"];
    }
    if (filter.housearea && filter.housearea.length > 0)
    {
        [param setValue:filter.housearea forKey:@"housearea"];
    }
    if (filter.houseurban && filter.houseurban.length > 0)
    {
        [param setValue:filter.houseurban forKey:@"houseurban"];
    }
    if (filter.fitment_type && filter.fitment_type.length > 0)
    {
        [param setValue:filter.fitment_type forKey:@"fitment_type"];
    }
    if (filter.house_floor_from && filter.house_floor_from.length > 0)
    {
        [param setValue:filter.house_floor_from forKey:@"house_floor_from"];
    }
    if (filter.house_floor_to && filter.house_floor_to.length > 0)
    {
        [param setValue:filter.house_floor_to forKey:@"house_floor_to"];
    }
    if (filter.sale_value_from && filter.sale_value_from.length > 0)
    {
        [param setValue:filter.sale_value_from forKey:@"sale_value_from"];
    }
    if (filter.sale_value_to && filter.sale_value_to.length > 0)
    {
        [param setValue:filter.sale_value_to forKey:@"sale_value_to"];
    }
    if (filter.lease_value_from && filter.lease_value_from.length > 0)
    {
        [param setValue:filter.lease_value_from forKey:@"lease_value_from"];
    }
    if (filter.lease_value_to && filter.lease_value_to.length > 0)
    {
        [param setValue:filter.lease_value_to forKey:@"lease_value_to"];
    }
    if (filter.keyword && filter.keyword.length > 0)
    {
        [param setValue:filter.keyword forKey:@"keyword"];
    }
    if (filter.FromID && filter.FromID.length > 0)
    {
        [param setValue:filter.FromID forKey:@"FromID"];
    }
    if (filter.ToID && filter.ToID.length > 0)
    {
        [param setValue:filter.ToID forKey:@"ToID"];
    }
    if (filter.Count && filter.Count.length > 0)
    {
        [param setValue:filter.Count forKey:@"Count"];
    }
    
    [NetWorkManager PostWithApiName:API_HOUSE_LIST parameters:param success:^(id responseObject)
     {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         if ([bizManager checkReturnStatus:resultDic Success:success failure:failure ShouldReturnWhenSuccess:NO])
         {

             NSArray *src = [resultDic objectForKey:@"EstateNode"];
             NSMutableArray *dst = [NSMutableArray array];
             for (NSDictionary *d in src)
             {
                 HouseDetail *o = [[HouseDetail alloc] init];
                 [o initWithDictionary:d];
                 [dst addObject:o];
             }
             success(dst);
         }
     }
                            failure:^(NSError *error)
     {
         failure(error);
     }];

}


@end
