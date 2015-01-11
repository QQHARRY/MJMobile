//
//  AppointDetailCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *object;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UILabel *rank;
@property (strong, nonatomic) IBOutlet UILabel *dept;
@property (strong, nonatomic) IBOutlet UILabel *man;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
