//
//  ContractDetailCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContractDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (strong, nonatomic) IBOutlet UILabel *dept;
@property (strong, nonatomic) IBOutlet UILabel *man;
@property (strong, nonatomic) IBOutlet UILabel *limit;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *ttype;

@end
