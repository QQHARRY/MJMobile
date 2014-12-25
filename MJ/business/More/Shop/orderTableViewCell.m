//
//  orderTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/24.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "orderTableViewCell.h"

@implementation orderTableViewCell

@synthesize oderByPerson;
@synthesize goodName;
@synthesize goodType;
@synthesize price;
@synthesize count;
@synthesize total;
@synthesize date;
@synthesize status;
@synthesize sendDate;
@synthesize receiveDate;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
