//
//  HouseAddKeyTalbeViewController.h
//  MJ
//
//  Created by harry on 15/7/4.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "HouseParticulars.h"


@interface HouseAddKeyTalbeViewController : UITableViewController<RETableViewManagerDelegate>

@property(nonatomic,strong)NSString*trade_no;
@property(nonatomic,strong)NSArray*roleList;
@end
