//
//  BuildingsSelectTableViewController.h
//  MJ
//
//  Created by harry on 15/1/17.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "buildings.h"

@interface BuildingsSelectTableViewController : UITableViewController


@property(nonatomic,assign)BOOL needRefresh;

@property(nonatomic,weak)id weakDelegate;

@property(nonatomic,strong) void(^handler)(buildings*) ;

+(id)initWithDelegate:(id)dele AndCompleteHandler:(void (^)(buildings*bld))hdl;

@end
