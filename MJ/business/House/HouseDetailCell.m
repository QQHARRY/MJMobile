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
    
    //self.publicDaysLeft.layer.masksToBounds = YES;
    self.publicDaysLeft.layer.cornerRadius = 5;
    self.publicDaysLeft.layer.borderWidth = 1;
    
    self.lookPermit.layer.borderColor = self.lookPermit.textColor.CGColor;
    self.lookPermit.layer.borderWidth = 0.5;
    
    self.consignmentType.layer.borderColor = self.consignmentType.textColor.CGColor;
    self.consignmentType.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setPublicStatus:(NSInteger)status AndLeftDays:(NSString*)leftDays
{
    if (status == 99)
    {
        self.publicDaysLeft.hidden = YES;
    }
    else
    {
        self.publicDaysLeft.hidden = NO;
    }
    
    //0：个人私盘；1：门店公盘；2：区域公盘；3：大区域公盘；99：公司公盘
    UIImage*image = nil;
    UIColor*color = nil;
    switch (status)
    {
        case 0:
        {
            image = [UIImage imageNamed:@"私"];
            color = [UIColor colorWithRed:0xf9/255.0 green:0x39/255.0 blue:0x25/255.0 alpha:1];
        }
            break;
        case 1:
        {
            image = [UIImage imageNamed:@"店"];
            color = [UIColor colorWithRed:0x04/255.0 green:0x3b/255.0 blue:0xc7/255.0 alpha:1];
        }
            break;
        case 2:
        {
            image = [UIImage imageNamed:@"区"];
            color = [UIColor colorWithRed:0x2a/255.0 green:0xa6/255.0 blue:0x05/255.0 alpha:1];
        }
            break;
        case 3:
        {
            image = [UIImage imageNamed:@"城"];
            color = [UIColor colorWithRed:0x69/255.0 green:0x00/255.0 blue:0xe9/255.0 alpha:1];
        }
            break;
        case 99:
        {
            image = [UIImage imageNamed:@"公"];
            color = [UIColor colorWithRed:0xe5/255.0 green:0x00/255.0 blue:0x43/255.0 alpha:1];
        }
            break;
        default:
        {
            image = [UIImage imageNamed:@"店"];
            color = [UIColor colorWithRed:0x04/255.0 green:0x3b/255.0 blue:0xc7/255.0 alpha:1];
        }
            break;
    }
    
    self.publicStatus.image = image;
    self.publicDaysLeft.text = [NSString stringWithFormat:@"     %@",leftDays];
    self.publicDaysLeft.textColor = color;
    self.publicDaysLeft.layer.borderColor = color.CGColor;
}



@end
