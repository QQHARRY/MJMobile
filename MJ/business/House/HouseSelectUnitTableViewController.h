//
//  HouseSelectUnitTableViewController.h
//  MJ
//
//  Created by harry on 15/6/29.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "building.h"
#import "houseUnit.h"

@interface HouseSelectUnitTableViewController : UITableViewController


@property(nonatomic,copy)NSString*buildingNO;//栋座信息

@property(nonatomic,weak)id weakDelegate;
@property(nonatomic,strong) void(^handler)(houseUnit*) ;


+(id)ctrlWithDelegate:(id)dele BuildingNo:(NSString*)bldingNo AndCompleteHandler:(void (^)(houseUnit*houseUnt))hdl;

@end
