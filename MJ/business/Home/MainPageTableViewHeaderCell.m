//
//  MainPageTableViewHeaderCell.m
//  MJ
//
//  Created by harry on 14-12-6.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "MainPageTableViewHeaderCell.h"

@implementation MainPageTableViewHeaderCell

- (void)awakeFromNib {
    // Initialization code
    self.action = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (IBAction)btnClicked:(id)sender
{
    if (self.action)
    {
        self.action(sender);
    }
}

-(void)initWithTitle:(NSString*)title andAction:(void(^)(UIButton*))act
{
    self.titleLab.text = title;
    self.action = act;
}
@end
