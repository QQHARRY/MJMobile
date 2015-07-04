//
//  FollowTableViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseDetail.h"
#import "HouseParticulars.h"

typedef NS_ENUM(NSUInteger, FollowType)
{
    K_FOLLOW_TYPE_HOUSE = 0,
    K_FOLLOW_TYPE_CUSTOMER
};




@interface FollowTableViewController : UITableViewController

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL hasAddPermit;
@property (nonatomic, strong) HouseDetail*houseDtl;
@property (nonatomic, strong) HouseParticulars*housePtcl;
@property (nonatomic, assign) FollowType followType;

@end
