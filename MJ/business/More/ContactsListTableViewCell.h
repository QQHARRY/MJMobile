//
//  ContactsListTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/16.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "unit.h"

@interface ContactsListTableViewCell : UITableViewCell


@property (strong, nonatomic)  UIButton *expandBtn;
@property (strong, nonatomic)  UILabel *unitName;
@property (strong, nonatomic)  UIButton*selectBtn;
@property (assign, nonatomic) long tag;

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) unit*unitKeeped;



- (IBAction)expandBtnClicked:(id)sender;


-(void)setUnit:(unit*)unt withTag:(long)tag delegate:(id)dele action:(SEL)action Selected:(BOOL)selected;

-(void)setBeSelected:(BOOL)selected;
@end
