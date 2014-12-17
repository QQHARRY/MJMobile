//
//  CantactListUnitTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/14.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "unit.h"
@interface ContactListUnitTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *expandBtn;
@property (strong, nonatomic) IBOutlet UILabel *unitName;
@property (assign, nonatomic) long tag;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) NSInteger level;


-(void)setUnit:(unit*)unt withTag:(long)tag action:(SEL)action;
@end
