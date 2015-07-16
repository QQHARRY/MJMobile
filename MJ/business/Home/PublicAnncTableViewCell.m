//
//  PublicAnncTableViewCell.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "PublicAnncTableViewCell.h"

@implementation PublicAnncTableViewCell

- (void)awakeFromNib {
    // Initialization code
     //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
   
}

-(void)initWithTitle:(NSString*)title isNew:(BOOL)isNew
{

    self.title.text = title;

    //self.isNew.hidden = !isNew;
}

@end
