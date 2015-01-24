//
//  HouseAddNewViewController.h
//  MJ
//
//  Created by harry on 15/1/14.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseParticularTableViewController.h"
#import "buildings.h"

@interface HouseAddNewViewController : HouseParticularTableViewController

@property(nonatomic,strong)buildings*curBuildings;
@property(weak,nonatomic)id delegate;
@end
