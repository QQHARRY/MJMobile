//
//  AlertDetailsTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "alert.h"

@interface AlertDetailsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *alertTime;
@property (strong, nonatomic) IBOutlet UILabel *sourceFrom;
@property (strong, nonatomic) IBOutlet UILabel *clientName;
@property (strong, nonatomic) IBOutlet UILabel *alertContent;
@property (strong, nonatomic) IBOutlet UILabel *alertPerson;
@property (strong, nonatomic) IBOutlet UILabel *alertType;


-(void)setAlert:(alert*)alert;
@end
