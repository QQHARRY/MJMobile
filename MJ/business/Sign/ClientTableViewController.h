//
//  ClientTableViewController.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientFilter.h"

@interface ClientTableViewController : UITableViewController

@property (nonatomic) ClientFilter *filter;
@property (nonatomic, weak) id container;

@end
