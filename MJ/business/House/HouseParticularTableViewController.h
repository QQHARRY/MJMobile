//
//  HouseParticularTableViewController.h
//  MJ
//
//  Created by harry on 15/1/10.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"
#import "houseSecretParticulars.h"

@interface HouseParticularTableViewController : UITableViewController<RETableViewManagerDelegate>

@property(strong,nonatomic)HouseDetail*houseDtl;
@property(strong,nonatomic)HouseParticulars*housePtcl;
@property(strong,nonatomic)houseSecretParticulars*houseSecretPtcl;
@property(strong,nonatomic)NSArray*editFieldsArr;

@end
