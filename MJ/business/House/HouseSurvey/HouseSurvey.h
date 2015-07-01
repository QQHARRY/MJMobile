//
//  HouseSurvey.h
//  MJ
//
//  Created by harry on 15/6/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "bizManager.h"
#import "HouseDetail.h"
#import "RoleListNode.h"

@interface HouseSurvey : bizManager


-(void)startSurveyWithHouse:(HouseDetail*)house RoleList:(NSArray*)roleList InVc:(UIViewController*)viewController;
@end
