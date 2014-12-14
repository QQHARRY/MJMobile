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

@property(nonatomic,strong)NSString* task_follow_no;//跟进id
@property(nonatomic,strong)NSString* task_reminder_flg;//是否已读
@property(nonatomic,strong)NSString* trade_type;//交易类型，字典表
@property(nonatomic,strong)NSString* client_name;//客户姓名
@property(nonatomic,strong)NSString* task_obj_no;//客户编号或房源编号
@property(nonatomic,strong)NSString* task_type;//跟进类型,电话还是短信等,字典表
@property(nonatomic,strong)NSString* task_reminder_date;//提醒日期
@property(nonatomic,strong)NSString* task_reminder_content;//提醒内容
@property(nonatomic,strong)NSString* name_full;//跟进人

@end
