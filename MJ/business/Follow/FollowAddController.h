//
//  FollowAddController.h
//  RETableViewManagerExample
//
//  Created by Roman Efimov on 2/28/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HouseViewController.h"
#import "FollowTableViewController.h"
#import "houseSecretParticulars.h"
#import "HouseDetail.h"
#import "HouseParticulars.h"




@interface FollowAddController : UITableViewController
    <RETableViewManagerDelegate>

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) FollowType followType;
@property (nonatomic, strong) HouseDetail*houseDtl;
@property (nonatomic, strong) HouseParticulars*housePtcl;
@property (nonatomic, strong) houseSecretParticulars*houseSecretPtcl;

@end
