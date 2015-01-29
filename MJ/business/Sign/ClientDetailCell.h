//
//  ClientDetailCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *require;
@property (strong, nonatomic) IBOutlet UILabel *sales;
@property (strong, nonatomic) IBOutlet UILabel *depart;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
