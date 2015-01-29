//
//  editCustomerTableViewController.h
//  MJ
//
//  Created by harry on 15/1/27.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addCustomerTableViewController.h"
#import "CustomerParticulars.h"
#import "CustomerSecret.h"

@interface editCustomerTableViewController : addCustomerTableViewController

+(editCustomerTableViewController*)editCtrlWithCusParticulars:(CustomerParticulars*)ptl AndSecrect:(CustomerSecret*)secret  AreaDic:(NSArray*)areaDic Hander:(void(^)())selectionHandler;
@property(strong,nonatomic)CustomerParticulars*cusPtrl;
@property(strong,nonatomic)CustomerSecret*cusSecretPtrl;
@property(strong,nonatomic)void(^handler)();

@end
