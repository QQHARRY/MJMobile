//
//  PublicAnncTableViewCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicAnncTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *isNew;
@property (strong, nonatomic) IBOutlet UILabel *title;


-(void)initWithTitle:(NSString*)title isNew:(BOOL)isNew;
@end
