//
//  ContactPersonDetailsVCTableViewCell.m
//  MJ
//
//  Created by harry on 15/4/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import "ContactPersonDetailsVCTableViewCell.h"

@implementation ContactPersonDetailsVCTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.value.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.value.layer.borderWidth = 0.5;
    self.value.layer.cornerRadius = 5;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setEditAble:(BOOL)editAble
{
    if (editAble)
    {
        self.value.layer.borderWidth = 1;
    }
    else
    {
        self.value.layer.borderWidth = 0;
    }
    
    self.value.scrollEnabled = editAble;
    self.value.selectable = editAble;
    self.value.editable = editAble;
}



@end
