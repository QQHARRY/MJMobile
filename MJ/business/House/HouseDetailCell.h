//
//  HouseDetailCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thunmbnail;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *house;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *floor;
@property (strong, nonatomic) IBOutlet UILabel *fitment;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *lookPermit;
@property (strong, nonatomic) IBOutlet UILabel *consignmentType;
@property (strong, nonatomic) IBOutlet UILabel *area;
@property (strong, nonatomic) IBOutlet UIImageView *publicStatus;
@property (strong, nonatomic) IBOutlet UILabel *publicDaysLeft;

@end
