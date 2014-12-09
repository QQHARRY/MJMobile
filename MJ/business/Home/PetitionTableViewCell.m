//
//  PetitionTableViewCell.m
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "PetitionTableViewCell.h"

@implementation PetitionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithType:(NSString*)type reason:(NSString*)reason person:(NSString*)person
{
    self.type.text = type;
    self.reason.text = reason;
    self.person.text = person;
    
}

@end
