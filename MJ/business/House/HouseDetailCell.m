//
//  HouseDetailCell.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "HouseDetailCell.h"

@implementation HouseDetailCell

- (void)awakeFromNib
{
    // Initialization code
     //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.fitment.layer.borderColor = self.fitment.textColor.CGColor;
    self.fitment.layer.borderWidth = 0.5;
    self.status.layer.borderColor = self.status.textColor.CGColor;
    self.status.layer.borderWidth = 0.5;
    
    self.lookPermit.layer.borderColor = self.status.textColor.CGColor;
    self.lookPermit.layer.borderWidth = 0.5;
    
    self.consignmentType.layer.borderColor = self.status.textColor.CGColor;
    self.consignmentType.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
