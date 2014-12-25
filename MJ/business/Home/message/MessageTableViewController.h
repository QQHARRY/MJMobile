//
//  MessageTableViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MJMESSAGETYPE) {
    MJMESSAGETYPE_UNREAD       = 0,
    MJMESSAGETYPE_READED     = 1,
};

@interface MessageTableViewController : UITableViewController

@property(nonatomic,assign)MJMESSAGETYPE msgType;


@property(nonatomic,strong)NSMutableArray*msgArr;

@property(weak,nonatomic)id container;

@end
