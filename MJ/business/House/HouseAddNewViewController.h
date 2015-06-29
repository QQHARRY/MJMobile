//
//  HouseAddNewViewController.h
//  MJ
//
//  Created by harry on 15/1/14.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseParticularTableViewController.h"
#import "buildings.h"
#import "building.h"
#import "buildingDetails.h"
#import "houseParticulars.h"
#import "houseUnit.h"

@interface HouseAddNewViewController : HouseParticularTableViewController<UIAlertViewDelegate>

@property(nonatomic,strong)buildings*curBuildings;//当前选择的楼盘
@property(nonatomic,strong)building*curBuilding;//当前选择的栋座
@property(nonatomic,strong)houseUnit*curHouseUnit;//当前选择的单元
@property(weak,nonatomic)id delegate;
@property(nonatomic,strong)NSMutableArray*curBuilidngsOfCurBuildings;//楼盘中的所有栋座
@property(nonatomic,strong)buildingDetails*curBuildingsDetails;

@end
