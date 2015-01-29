//
//  AlertDetailsTableViewCell.m
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "AlertDetailsTableViewCell.h"

@implementation AlertDetailsTableViewCell

@synthesize alertTime;
@synthesize sourceFrom;
@synthesize clientName;
@synthesize alertContent;
@synthesize alertPerson;
@synthesize alertType;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAlert:(alert*)alert
{
    alertTime.text = alert.task_reminder_date;
    if ([[alert.task_follow_no  substringToIndex:1]  isEqualToString:@"HT"])
    {
        sourceFrom.text = @"房源跟进";
    }
    else
    {
        sourceFrom.text = @"客源跟进";
    }
    
    clientName.text = alert.client_name;
    alertContent.text = alert.task_reminder_content;
    alertPerson.text = alert.name_full;
    alertType.text = alert.task_type;
    
}

@end
