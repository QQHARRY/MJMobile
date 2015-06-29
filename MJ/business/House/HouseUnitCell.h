//
//  HouseUnitCell.h
//  MJ
//
//  Created by harry on 15/6/29.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseUnitCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *unitName;
@property (strong, nonatomic) IBOutlet UILabel *floorCount;
@property (strong, nonatomic) IBOutlet UILabel *elevatorCount;
@property (strong, nonatomic) IBOutlet UILabel *houseCount;

@end
