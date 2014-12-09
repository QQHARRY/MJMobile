//
//  PetitionTableViewCell.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetitionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *person;
@property (strong, nonatomic) IBOutlet UILabel *reason;


-(void)initWithType:(NSString*)type reason:(NSString*)reason person:(NSString*)person;
@end
