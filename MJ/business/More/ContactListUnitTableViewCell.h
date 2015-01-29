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
@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) long tag;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) NSInteger level;

- (IBAction)expandBtnClicked:(id)sender;

-(void)setUnit:(unit*)unt withTag:(long)tag delegate:(id)dele action:(SEL)action;
@end
