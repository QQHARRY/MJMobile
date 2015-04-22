//
//  ContactPsnVCCellTableViewCell.h
//  MJ
//
//  Created by harry on 15/4/22.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPsnVCCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *psnImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *msgBtn;
@property (strong, nonatomic) IBOutlet UIButton *phoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *imBtn;



@end
