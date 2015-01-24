//
//  buildingsFilterViewController.h
//  MJ
//
//  Created by harry on 15/1/17.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "BuildingsSelectTableViewController.h"

@interface buildingsFilterViewController : UITableViewController<RETableViewManagerDelegate>

@property(nonatomic,strong)NSMutableDictionary*queryCondition;

@property(nonatomic,weak)BuildingsSelectTableViewController*buildingsSel;
@end
