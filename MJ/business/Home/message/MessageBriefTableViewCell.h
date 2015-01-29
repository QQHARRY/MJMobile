//
//  MessageBriefTableViewCell.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBriefTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *receiver;
@property (strong, nonatomic) IBOutlet UILabel *msgSender;
@property (strong, nonatomic) IBOutlet UILabel *briefContent;
@property (strong, nonatomic) IBOutlet UILabel *sendTime;

@end
