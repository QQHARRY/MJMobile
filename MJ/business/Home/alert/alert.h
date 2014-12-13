//
//  alert.h
//  MJ
//
//  Created by harry on 14/12/13.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"

@interface alert : dic2Object

@property(nonatomic,strong)NSString* task_follow_no;
@property(nonatomic,strong)NSString* task_reminder_flg;
@property(nonatomic,strong)NSString* trade_type;
@property(nonatomic,strong)NSString* client_name;
@property(nonatomic,strong)NSString* task_obj_no;
@property(nonatomic,strong)NSString* task_type;
@property(nonatomic,strong)NSString* task_rem;
@property(nonatomic,strong)NSString* task_reminder_content;
@property(nonatomic,strong)NSString* name_full;

@end
