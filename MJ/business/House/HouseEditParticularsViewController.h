//
//  HouseEditParticularsViewController.h
//  MJ
//
//  Created by harry on 15/1/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "HouseParticularTableViewController.h"

@interface HouseEditParticularsViewController : HouseParticularTableViewController<UIAlertViewDelegate>

@property(strong,nonatomic)HouseDetail*houseDtl;
@property(strong,nonatomic)HouseParticulars*housePtcl;
@property(strong,nonatomic)houseSecretParticulars*houseSecretPtcl;

@property(weak,nonatomic)id delegate;
@end
