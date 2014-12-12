//
//  announcement.h
//  MJ
//
//  Created by harry on 14-12-9.
//  Copyright (c) 2014年 Simtoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dic2Object.h"


@interface announcement : dic2Object


@property(strong,nonatomic)NSString*notice_title;
@property(strong,nonatomic)NSString*notice_no;
@property(strong,nonatomic)NSString*notice_content;
@property(strong,nonatomic)NSString*issue_date;
@property(strong,nonatomic)NSString*Brief;
@property(strong,nonatomic)NSString*issue_person_name;


@property(assign,nonatomic)BOOL isNew;


@end
