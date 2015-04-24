//
//  ContactPersonDetailsVCTableViewCell.h
//  MJ
//
//  Created by harry on 15/4/24.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPersonDetailsVCTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *typeImage;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UITextView *value;


-(void)setEditAble:(BOOL)editAble;


@end
