//
//  HouseSelectBuildingTableViewController.h
//  MJ
//
//  Created by harry on 15/1/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "building.h"
#import "buildings.h"

@interface HouseSelectBuildingTableViewController : UITableViewController

@property(strong,nonatomic)NSMutableArray*buildingsArr;
@property(nonatomic,strong) void(^handler)(building*) ;
@property(nonatomic,strong)buildings* blds;

+(id)initWithDelegate:(id)dele Buildings:(buildings*)bldings AndCompleteHandler:(void (^)(building*bld))hdl;

+(id)initWithDelegate:(id)dele BuildingsArr:(NSArray*)bldings AndCompleteHandler:(void (^)(building*bld))hdl;
@end
