//
//  cartTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cartTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *goodName;
@property (strong, nonatomic) IBOutlet UILabel *goodType;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property (strong, nonatomic) IBOutlet UILabel *total;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *status;

@end
