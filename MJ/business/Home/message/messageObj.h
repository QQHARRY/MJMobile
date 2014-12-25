//
//  messageObj.h
//  MJ
//
//  Created by harry on 14/12/25.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import "dic2Object.h"

@interface messageObj : dic2Object


@property(nonatomic,strong)NSString* msg_cno;
@property(nonatomic,strong)NSString* msg_index_cno;
@property(nonatomic,strong)NSString* msg_flag_no;
@property(nonatomic,strong)NSString* msg_title;
@property(nonatomic,strong)NSString* view_user_list;
@property(nonatomic,strong)NSString* msg_opt_user_list;
@property(nonatomic,strong)NSString* msg_cc_user_list;
@property(nonatomic,strong)NSString* mg_bcc_user_list;
@property(nonatomic,strong)NSString* view_user_list_name;
@property(nonatomic,strong)NSString* msg_opt_user_list_name;
@property(nonatomic,strong)NSString* msg_cc_user_list_name;
@property(nonatomic,strong)NSString* msg_bcc_user_list_name;
@property(nonatomic,strong)NSString* msg_content;
@property(nonatomic,strong)NSString* msg_save_date;
@property(nonatomic,strong)NSString* unread_flag;
@property(nonatomic,strong)NSString* collected;

@end
